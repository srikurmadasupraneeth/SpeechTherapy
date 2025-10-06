import Foundation

public struct FeedbackTip: Identifiable, Hashable {
    public let id = UUID()
    public let message: String
    public init(_ message: String) { self.message = message }
}

public protocol FeedbackEngine {
    func evaluate(metrics: [String: Double]) -> (score: Double, tips: [FeedbackTip])
}

public final class MockFeedbackEngine: FeedbackEngine {
    public init() {}
    public func evaluate(metrics: [String : Double]) -> (score: Double, tips: [FeedbackTip]) {
        (0.8, [FeedbackTip("Great job! Keep going")])
    }
}
