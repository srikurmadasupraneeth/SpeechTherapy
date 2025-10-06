import SwiftUI
import Charts

public struct ProgressViewScreen: View {
    public init() {}
    public var body: some View {
        VStack {
            Text("Weekly Progress")
            Chart(sampleData) { item in
                LineMark(x: .value("Day", item.day), y: .value("Score", item.score))
            }
            .frame(height: 200)
        }
        .padding()
    }
}

private struct ProgressItem: Identifiable { let id = UUID(); let day: String; let score: Double }
private let sampleData: [ProgressItem] = [
    .init(day: "Mon", score: 0.6),
    .init(day: "Tue", score: 0.7),
    .init(day: "Wed", score: 0.5),
    .init(day: "Thu", score: 0.8),
    .init(day: "Fri", score: 0.9)
]
