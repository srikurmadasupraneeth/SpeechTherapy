import Foundation
import Combine

public final class AppContainer: ObservableObject {
    public let audioCapture: AudioCaptureService
    public let speechRecognition: SpeechRecognitionService
    public let dsp: DSPFeatureService
    public let faceTracking: FaceTrackingService
    public let feedback: FeedbackEngine
    public let exporter: ExportService

    public init(audioCapture: AudioCaptureService,
                speechRecognition: SpeechRecognitionService,
                dsp: DSPFeatureService,
                faceTracking: FaceTrackingService,
                feedback: FeedbackEngine,
                exporter: ExportService) {
        self.audioCapture = audioCapture
        self.speechRecognition = speechRecognition
        self.dsp = dsp
        self.faceTracking = faceTracking
        self.feedback = feedback
        self.exporter = exporter
    }

    public static func mock() -> AppContainer {
        AppContainer(audioCapture: RealtimeAudioCaptureService(),
                     speechRecognition: AppleSpeechRecognitionService(),
                     dsp: MockDSPFeatureService(),
                     faceTracking: ARKitFaceTrackingService(),
                     feedback: HeuristicFeedbackEngine(),
                     exporter: PDFExportService())
    }
}
