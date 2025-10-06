import Foundation
import Domain

public final class InMemorySessionRepository: SessionRepository {
    private var sessions: [UUID: Session] = [:]
    public init() {}
    public func createSession(for userId: UUID) async throws -> Session {
        let session = Session(userId: userId)
        sessions[session.id] = session
        return session
    }
    public func endSession(_ sessionId: UUID) async throws {
        guard var s = sessions[sessionId] else { return }
        s.endedAt = .now
        sessions[sessionId] = s
    }
    public func getSessions(for userId: UUID) async throws -> [Session] {
        sessions.values.filter { $0.userId == userId }
    }
}

public final class InMemoryExerciseRepository: ExerciseRepository {
    private let items: [Exercise]
    public init(items: [Exercise] = []) { self.items = items }
    public func listExercises(languageCode: String?) async throws -> [Exercise] {
        guard let code = languageCode else { return items }
        return items.filter { $0.languageCode == code }
    }
}

public final class InMemoryRewardRepository: RewardRepository {
    public init() {}
    public func grant(points: Int, to userId: UUID) async throws -> Reward {
        Reward(name: "Points", points: points)
    }
    public func listRewards(for userId: UUID) async throws -> [Reward] {
        []
    }
}
