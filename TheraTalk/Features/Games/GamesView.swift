import SwiftUI

public struct GamesView: View {
    public init() {}
    public var body: some View {
        NavigationStack {
            List {
                NavigationLink("Balloon Burst (loudness)") { BalloonBurstView() }
                NavigationLink("Pitch Glider (intonation)") { PitchGliderView() }
                NavigationLink("Mirror Me (facial)") { MirrorMeView() }
            }
            .navigationTitle("Games")
        }
    }
}

struct BalloonBurstView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var level: Double = 0
    @State private var isRunning = false
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: level)
                .tint(.red)
            Button(isRunning ? "Stop" : "Start") {
                if isRunning { container.audioCapture.stop(); isRunning = false }
                else {
                    do { try container.audioCapture.configure(sampleRate: 22050); try container.audioCapture.start(); isRunning = true } catch {}
                    container.audioCapture.onMetrics = { m in level = m["level"] ?? 0 }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct PitchGliderView: View {
    var body: some View {
        Text("Pitch Glider prototype")
            .padding()
    }
}

struct MirrorMeView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var metrics: [String: Double] = [:]
    @State private var isRunning = false
    var body: some View {
        VStack(spacing: 16) {
            Text("jawOpen: \(String(format: "%.2f", metrics["jawOpen"] ?? 0))")
            Button(isRunning ? "Stop" : "Start") {
                if isRunning { container.faceTracking.stop(); isRunning = false }
                else { Task { try? await container.faceTracking.start(); isRunning = true } }
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear { container.faceTracking.onMetrics = { metrics = $0 } }
        .padding()
    }
}
