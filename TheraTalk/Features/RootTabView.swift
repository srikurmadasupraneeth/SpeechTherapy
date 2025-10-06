import SwiftUI
// Import feature modules once available
// import SpeechPractice
// import FacePractice

public struct RootTabView: View {
    public init() {}

    public var body: some View {
        TabView {
            SpeechPracticeView()
                .tabItem { Label(NSLocalizedString("tab.speech", comment: ""), systemImage: "mic") }
            FacePracticeView()
                .tabItem { Label(NSLocalizedString("tab.face", comment: ""), systemImage: "face.smiling") }
            GamesView()
                .tabItem { Label(NSLocalizedString("tab.games", comment: ""), systemImage: "gamecontroller") }
            ProgressViewScreen()
                .tabItem { Label(NSLocalizedString("tab.progress", comment: ""), systemImage: "chart.line.uptrend.xyaxis") }
            ReportsView()
                .tabItem { Label(NSLocalizedString("tab.reports", comment: ""), systemImage: "doc.text") }
            SettingsViewScreen()
                .tabItem { Label(NSLocalizedString("tab.settings", comment: ""), systemImage: "gearshape") }
        }
    }
}
