import SwiftUI
import Services

public struct SettingsViewScreen: View {
    @EnvironmentObject private var container: AppContainer
    public init() {}
    public var body: some View {
        Form {
            Toggle("Demo Mode", isOn: $container.isDemoMode)
        }
    }
}
