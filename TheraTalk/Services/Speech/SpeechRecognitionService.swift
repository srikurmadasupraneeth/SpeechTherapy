import Foundation

public protocol SpeechRecognitionService {
    func start(languageCode: String) async throws
    func stop()
}

public final class MockSpeechRecognitionService: SpeechRecognitionService {
    public init() {}
    public func start(languageCode: String) async throws {}
    public func stop() {}
}
