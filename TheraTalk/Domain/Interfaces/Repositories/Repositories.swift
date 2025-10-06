import Foundation

public protocol SessionRepository {
    func createSession(for userId: UUID) async throws -> Session
    func endSession(_ sessionId: UUID) async throws
    func getSessions(for userId: UUID) async throws -> [Session]
}

public protocol ExerciseRepository {
    func listExercises(languageCode: String?) async throws -> [Exercise]
}

public protocol RewardRepository {
    func grant(points: Int, to userId: UUID) async throws -> Reward
    func listRewards(for userId: UUID) async throws -> [Reward]
}
