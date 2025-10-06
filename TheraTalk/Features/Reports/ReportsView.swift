import SwiftUI
import Services

public struct ReportsView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var fileURL: URL?
    public init() {}
    public var body: some View {
        VStack(spacing: 16) {
            if let url = fileURL {
                Text("Exported: \(url.lastPathComponent)")
            }
            Button("Export PDF") {
                Task {
                    let data = Data() // replace with real session summary
                    fileURL = try? await container.exporter.export(sessionData: data)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
