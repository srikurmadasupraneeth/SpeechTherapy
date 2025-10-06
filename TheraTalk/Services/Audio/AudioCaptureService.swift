import AVFoundation
import Accelerate

public protocol AudioCaptureService: AnyObject {
    var onBuffer: ((AVAudioPCMBuffer) -> Void)? { get set }
    var onMetrics: (([String: Double]) -> Void)? { get set }
    func configure(sampleRate: Double) throws
    func start() throws
    func stop()
}

public final class RealtimeAudioCaptureService: AudioCaptureService {
    private let session = AVAudioSession.sharedInstance()
    private let engine = AVAudioEngine()
    private var sampleRate: Double = 22050

    public var onBuffer: ((AVAudioPCMBuffer) -> Void)?
    public var onMetrics: (([String: Double]) -> Void)?

    public init() {}

    public func configure(sampleRate: Double) throws {
        self.sampleRate = sampleRate
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .allowBluetooth])
        try session.setPreferredSampleRate(sampleRate)
        try session.setActive(true)
    }

    public func start() throws {
        let input = engine.inputNode
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false)!
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            self.onBuffer?(buffer)
            let metrics = Self.computeMetrics(buffer: buffer)
            self.onMetrics?(metrics)
        }
        engine.prepare()
        try engine.start()
    }

    public func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
    }

    private static func computeMetrics(buffer: AVAudioPCMBuffer) -> [String: Double] {
        guard let channelData = buffer.floatChannelData?[0] else { return [:] }
        let count = Int(buffer.frameLength)
        var rms: Float = 0
        vDSP_rmsqv(channelData, 1, &rms, vDSP_Length(count))
        let level = min(max((rms * 10), 0), 1)
        // Zero-crossing rate (simple proxy)
        var crossings: Int = 0
        for i in 1..<count {
            let a = channelData[i-1]
            let b = channelData[i]
            if (a >= 0 && b < 0) || (a < 0 && b >= 0) { crossings += 1 }
        }
        let zcr = Double(crossings) / Double(count)
        return ["rms": Double(rms), "level": Double(level), "zcr": zcr]
    }
}
