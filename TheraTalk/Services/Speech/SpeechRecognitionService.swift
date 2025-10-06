import Foundation
import Speech
import AVFoundation

public protocol SpeechRecognitionService: AnyObject {
    var isAuthorized: Bool { get }
    var partialTextHandler: ((String) -> Void)? { get set }
    var finalTextHandler: ((String) -> Void)? { get set }
    func requestAuthorization() async -> Bool
    func start(languageCode: String) async throws
    func appendAudioPCMBuffer(_ buffer: AVAudioPCMBuffer)
    func stop()
}

public final class AppleSpeechRecognitionService: NSObject, SpeechRecognitionService {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?

    public var partialTextHandler: ((String) -> Void)?
    public var finalTextHandler: ((String) -> Void)?

    public override init() { super.init() }

    public var isAuthorized: Bool {
        SFSpeechRecognizer.authorizationStatus() == .authorized
    }

    public func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    public func start(languageCode: String) async throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true

        recognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
        guard let recognizer = recognizer, recognizer.isAvailable else {
            throw NSError(domain: "Speech", code: -1, userInfo: [NSLocalizedDescriptionKey: "Recognizer unavailable"])
        }

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self else { return }
            if let result = result {
                if result.isFinal {
                    self.finalTextHandler?(result.bestTranscription.formattedString)
                } else {
                    self.partialTextHandler?(result.bestTranscription.formattedString)
                }
            }
            if error != nil {
                self.stop()
            }
        }
    }

    public func appendAudioPCMBuffer(_ buffer: AVAudioPCMBuffer) {
        recognitionRequest?.append(buffer)
    }

    public func stop() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
}
