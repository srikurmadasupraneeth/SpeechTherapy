import Foundation

public protocol FaceTrackingService {
    func start() async throws
    func stop()
}

public final class MockFaceTrackingService: FaceTrackingService {
    public init() {}
    public func start() async throws {}
    public func stop() {}
}
