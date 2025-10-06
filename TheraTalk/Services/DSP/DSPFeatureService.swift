import Foundation

public protocol DSPFeatureService {
    func computeMetrics(buffer: Data) -> [String: Double]
}

public final class MockDSPFeatureService: DSPFeatureService {
    public init() {}
    public func computeMetrics(buffer: Data) -> [String : Double] { [:] }
}
