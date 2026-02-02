import SwiftUI

/// Main design theme container for WPCUILibrary.
/// Components should depend on `Theme` (via ThemeProvider/Environment), never on raw tokens directly.
public struct Theme: Sendable {
    public let colors: SemanticColors
    public let typography: FontStyles
    public let spacing: Spacing
    public let radius: Radius
    public let elevation: Elevation

    public init(
        colors: SemanticColors,
        typography: FontStyles,
        spacing: Spacing = .tokens,
        radius: Radius = .tokens,
        elevation: Elevation = .tokens
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.elevation = elevation
    }
}

// MARK: - Defaults

public extension Theme {
    /// Default WPC theme (semantic mapping + system typography).
    static let wpcDefault = Theme(
        colors: .wpcDefault,
        typography: .wpcDefault,
        spacing: .tokens,
        radius: .tokens,
        elevation: .tokens
    )
}

// MARK: - Spacing wrapper

public struct Spacing: Sendable {
    public let xxs: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat

    public init(
        xxs: CGFloat,
        xs: CGFloat,
        sm: CGFloat,
        md: CGFloat,
        lg: CGFloat,
        xl: CGFloat,
        xxl: CGFloat,
        xxxl: CGFloat
    ) {
        self.xxs = xxs
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
    }
}

public extension Spacing {
    /// Bridges your current `SpacingTokens` (Double) into `CGFloat` for UI usage.
    static let tokens = Spacing(
        xxs: SpacingTokens.xxs,
        xs: SpacingTokens.xs,
        sm: SpacingTokens.sm,
        md: SpacingTokens.md,
        lg: SpacingTokens.lg,
        xl: SpacingTokens.xl,
        xxl: SpacingTokens.xxl,
        xxxl: SpacingTokens.xxxl
    )
}

// MARK: - Radius wrapper

public struct Radius: Sendable {
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let pill: CGFloat

    public init(xs: CGFloat, sm: CGFloat, md: CGFloat, lg: CGFloat, xl: CGFloat, pill: CGFloat) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.pill = pill
    }
}

public extension Radius {
    /// Bridges your current `RadiusTokens` (Double) into `CGFloat` for UI usage.
    static let tokens = Radius(
        xs: RadiusTokens.xs,
        sm: RadiusTokens.sm,
        md: RadiusTokens.md,
        lg: RadiusTokens.lg,
        xl: RadiusTokens.xl,
        pill: RadiusTokens.pill
    )
}

// MARK: - Elevation wrapper

public struct Elevation: Sendable {
    public let none: ElevationToken
    public let sm: ElevationToken
    public let md: ElevationToken
    public let lg: ElevationToken

    public init(none: ElevationToken, sm: ElevationToken, md: ElevationToken, lg: ElevationToken) {
        self.none = none
        self.sm = sm
        self.md = md
        self.lg = lg
    }
}

public extension Elevation {
    static let tokens = Elevation(
        none: ElevationTokens.none,
        sm: ElevationTokens.sm,
        md: ElevationTokens.md,
        lg: ElevationTokens.lg
    )
}

// MARK: - Convenience accessors (optional sugar)

public extension Theme {
    /// Convenience for common card radius.
    var cardRadius: CGFloat { radius.lg }

    /// Convenience for common screen padding.
    var screenPadding: CGFloat { spacing.lg }
}
