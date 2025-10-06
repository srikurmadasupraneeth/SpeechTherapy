import Foundation

public struct UserProfile: Identifiable, Codable, Hashable {
    public let id: UUID
    public var displayName: String
    public var preferredLanguageCode: String
    public var createdAt: Date
    public init(id: UUID = UUID(), displayName: String, preferredLanguageCode: String, createdAt: Date = .now) {
        self.id = id
        self.displayName = displayName
        self.preferredLanguageCode = preferredLanguageCode
        self.createdAt = createdAt
    }
}

public struct Exercise: Identifiable, Codable, Hashable {
    public enum Kind: String, Codable, CaseIterable { case speech, face, game }
    public let id: UUID
    public var title: String
    public var kind: Kind
    public var languageCode: String
    public init(id: UUID = UUID(), title: String, kind: Kind, languageCode: String) {
        self.id = id
        self.title = title
        self.kind = kind
        self.languageCode = languageCode
    }
}

public struct MetricSnapshot: Identifiable, Codable, Hashable {
    public let id: UUID
    public var timestamp: Date
    public var values: [String: Double]
    public init(id: UUID = UUID(), timestamp: Date = .now, values: [String: Double]) {
        self.id = id
        self.timestamp = timestamp
        self.values = values
    }
}

public struct Trial: Identifiable, Codable, Hashable {
    public let id: UUID
    public var exerciseId: UUID
    public var startedAt: Date
    public var endedAt: Date?
    public var score: Double?
    public var metrics: [MetricSnapshot]
    public init(id: UUID = UUID(), exerciseId: UUID, startedAt: Date = .now, endedAt: Date? = nil, score: Double? = nil, metrics: [MetricSnapshot] = []) {
        self.id = id
        self.exerciseId = exerciseId
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.score = score
        self.metrics = metrics
    }
}

public struct Session: Identifiable, Codable, Hashable {
    public let id: UUID
    public var userId: UUID
    public var startedAt: Date
    public var endedAt: Date?
    public var trials: [Trial]
    public init(id: UUID = UUID(), userId: UUID, startedAt: Date = .now, endedAt: Date? = nil, trials: [Trial] = []) {
        self.id = id
        self.userId = userId
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.trials = trials
    }
}

public struct Reward: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var points: Int
    public init(id: UUID = UUID(), name: String, points: Int) {
        self.id = id
        self.name = name
        self.points = points
    }
}
