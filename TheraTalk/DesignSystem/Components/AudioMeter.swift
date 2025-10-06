import SwiftUI

public struct AudioMeter: View {
    public var level: Double
    public init(level: Double) { self.level = level }
    public var body: some View {
        ProgressView(value: min(max(level, 0), 1))
    }
}
