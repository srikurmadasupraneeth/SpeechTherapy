import Foundation

public protocol ExportService {
    func export(sessionData: Data) async throws -> URL
}

public final class MockExportService: ExportService {
    public init() {}
    public func export(sessionData: Data) async throws -> URL { URL(fileURLWithPath: "/dev/null") }
}
