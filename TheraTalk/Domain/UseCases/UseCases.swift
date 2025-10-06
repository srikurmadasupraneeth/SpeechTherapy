import Foundation

public protocol RunSpeechExerciseUseCase {
    func start(exercise: Exercise, userId: UUID) async throws -> Trial
}

public protocol RunFaceExerciseUseCase {
    func start(exercise: Exercise, userId: UUID) async throws -> Trial
}

public protocol ScoreAttemptUseCase {
    func score(trial: Trial, metrics: [MetricSnapshot]) async throws -> Trial
}

public protocol GenerateReportUseCase {
    func generate(for session: Session) async throws -> Data
}
