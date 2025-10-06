import SwiftUI

public struct FaceGuideOverlay: View {
    public init() {}
    public var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
            .foregroundColor(.blue)
            .opacity(0.4)
    }
}
