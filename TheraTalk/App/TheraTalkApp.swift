import SwiftUI
import Features
import Services

@main
public struct TheraTalkApp: App {
    @StateObject private var container = AppContainer.mock()

    public init() {}

    public var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(container)
        }
    }
}
