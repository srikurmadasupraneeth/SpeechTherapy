import SwiftUI
import AVFoundation
import Services

public struct SpeechPracticeView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var recognizedText: String = ""
    @State private var level: Double = 0
    @State private var authorized = false
    @State private var isRunning = false
    @State private var target: String = "Hello"

    public init() {}
    public var body: some View {
        VStack(spacing: 16) {
            Text("Target: \(target)")
            Text(recognizedText)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            ProgressView(value: level)
                .tint(.green)
                .padding(.horizontal)

            HStack {
                Button(isRunning ? "Stop" : "Start") {
                    Task { await toggle() }
                }
                .buttonStyle(.borderedProminent)

                Button("Change Word") {
                    target = ["Hello","Banana","Tomato","डेढ़","வணக்கம்"].randomElement() ?? "Hello"
                }
            }
        }
        .padding()
        .task { await setup() }
    }

    private func setup() async {
        if !authorized {
            _ = await container.speechRecognition.requestAuthorization()
            authorized = container.speechRecognition.isAuthorized
        }
        do { try container.audioCapture.configure(sampleRate: 22050) } catch { }
        container.audioCapture.onBuffer = { buffer in
            container.speechRecognition.appendAudioPCMBuffer(buffer)
        }
        container.audioCapture.onMetrics = { metrics in
            level = metrics["level"] ?? 0
        }
        container.speechRecognition.partialTextHandler = { text in
            recognizedText = text
        }
        container.speechRecognition.finalTextHandler = { text in
            recognizedText = text
        }
    }

    private func toggle() async {
        if isRunning {
            container.speechRecognition.stop()
            container.audioCapture.stop()
            isRunning = false
        } else {
            do {
                try container.audioCapture.start()
                try await container.speechRecognition.start(languageCode: Locale.current.identifier)
                isRunning = true
            } catch {
                isRunning = false
            }
        }
    }
}
