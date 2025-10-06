import SwiftUI
import ARKit
import Services

public struct FacePracticeView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var metrics: [String: Double] = [:]
    @State private var isRunning = false
    @State private var target: [String: Double] = [
        "jawOpen": 0.5,
        "mouthFunnel": 0.3
    ]

    public init() {}
    public var body: some View {
        VStack(spacing: 16) {
            Text("Jaw Open: \(String(format: "%.2f", metrics["jawOpen"] ?? 0))")
            Text("Mouth Funnel: \(String(format: "%.2f", metrics["mouthFunnel"] ?? 0))")
            Button(isRunning ? "Stop" : "Start") { toggle() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            if container.isDemoMode {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    let t = Date().timeIntervalSince1970
                    metrics["jawOpen"] = (sin(t * 2) * 0.25 + 0.5).clamped(to: 0...1)
                    metrics["mouthFunnel"] = (cos(t * 1.6) * 0.2 + 0.3).clamped(to: 0...1)
                }
            } else {
                container.faceTracking.onMetrics = { new in metrics = new }
            }
        }
    }

    private func toggle() {
        if isRunning {
            container.faceTracking.stop()
            isRunning = false
        } else {
            Task { try? await container.faceTracking.start(); isRunning = true }
        }
    }
}
