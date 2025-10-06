import Foundation
import PDFKit

public protocol ExportService {
    func export(sessionData: Data) async throws -> URL
}

public final class PDFExportService: ExportService {
    public init() {}
    public func export(sessionData: Data) async throws -> URL {
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TheraTalk-Report.pdf")
        let pdf = PDFDocument()
        let page = PDFPage()
        pdf.insert(page!, at: 0)
        pdf.write(to: tmp)
        return tmp
    }
}
