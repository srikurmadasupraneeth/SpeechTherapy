import AVFoundation

public protocol AudioCaptureService {
    func start() throws
    func stop()
}

public final class MockAudioCaptureService: AudioCaptureService {
    public init() {}
    public func start() throws {}
    public func stop() {}
}
