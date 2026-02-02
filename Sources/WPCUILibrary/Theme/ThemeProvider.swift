import SwiftUI

// MARK: - Environment Key

private struct WPCThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .wpcDefault
}

public extension EnvironmentValues {
    /// Access to the current WPC theme within the view hierarchy.
    var wpcTheme: Theme {
        get { self[WPCThemeKey.self] }
        set { self[WPCThemeKey.self] = newValue }
    }
}

// MARK: - View Modifier

public extension View {
    /// Injects a WPC Theme into the view hierarchy.
    ///
    /// Usage:
    /// ```
    /// ContentView()
    ///   .wpcTheme(.wpcDefault)
    /// ```
    func wpcTheme(_ theme: Theme) -> some View {
        environment(\.wpcTheme, theme)
    }
}

// MARK: - Optional Provider Wrapper

/// Wrapper view for adding a theme to a subtree.
/// Esto es opcional (muchos DS lo incluyen como azúcar sintáctico).
public struct ThemeProvider<Content: View>: View {
    private let theme: Theme
    private let content: Content

    public init(theme: Theme = .wpcDefault, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.wpcTheme, theme)
    }
}
