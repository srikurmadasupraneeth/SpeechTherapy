import Foundation

public struct FeedbackTip: Identifiable, Hashable {
    public let id = UUID()
    public let message: String
    public init(_ message: String) { self.message = message }
}

public protocol FeedbackEngine {
    func evaluateSpeech(rms: Double?, pitchZCR: Double?, recognized: String?, target: String?) -> (score: Double, tips: [FeedbackTip])
    func evaluateFace(metrics: [String: Double], target: [String: Double]) -> (score: Double, tips: [FeedbackTip])
}

public final class HeuristicFeedbackEngine: FeedbackEngine {
    public init() {}

    public func evaluateSpeech(rms: Double?, pitchZCR: Double?, recognized: String?, target: String?) -> (score: Double, tips: [FeedbackTip]) {
        var score = 0.0
        var tips: [FeedbackTip] = []

        if let text = recognized, let goal = target, !goal.isEmpty {
            let dist = Self.levenshtein(aStr: text.lowercased(), bStr: goal.lowercased())
            let maxLen = max(text.count, goal.count)
            let acc = max(0.0, 1.0 - Double(dist) / Double(maxLen == 0 ? 1 : maxLen))
            score += acc * 0.6
            if acc < 0.8 { tips.append(FeedbackTip("Try again slowly and clearly")) }
        }
        if let r = rms {
            let loudnessScore = min(max((r * 10), 0), 1)
            score += loudnessScore * 0.2
            if loudnessScore < 0.4 { tips.append(FeedbackTip("Speak a bit louder")) }
        }
        if let z = pitchZCR {
            // Prefer moderate ZCR range as proxy for voiced speech stability
            let stability = 1.0 - min(abs(z - 0.05) / 0.05, 1.0)
            score += stability * 0.2
            if stability < 0.5 { tips.append(FeedbackTip("Keep a steady tone")) }
        }
        return (min(score, 1.0), tips)
    }

    public func evaluateFace(metrics: [String : Double], target: [String : Double]) -> (score: Double, tips: [FeedbackTip]) {
        var score = 0.0
        var tips: [FeedbackTip] = []
        var count = 0
        for (k, v) in target {
            count += 1
            let actual = metrics[k] ?? 0
            if actual >= v { score += 1 }
            else { tips.append(FeedbackTip("Increase \(k) more")) }
        }
        let normalized = count > 0 ? score / Double(count) : 0
        return (normalized, tips)
    }

    private static func levenshtein(aStr: String, bStr: String) -> Int {
        let a = Array(aStr)
        let b = Array(bStr)
        var dist = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        for i in 0...a.count { dist[i][0] = i }
        for j in 0...b.count { dist[0][j] = j }
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i - 1] == b[j - 1] {
                    dist[i][j] = dist[i - 1][j - 1]
                } else {
                    dist[i][j] = min(dist[i - 1][j] + 1, min(dist[i][j - 1] + 1, dist[i - 1][j - 1] + 1))
                }
            }
        }
        return dist[a.count][b.count]
    }
}
