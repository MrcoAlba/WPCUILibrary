import SwiftUI

/// Semantic colors: UI components should depend on these, not raw palette tokens.
/// This makes theming and future brand changes easy.
public struct SemanticColors: Sendable {
    // Text
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let textInverse: Color

    // Background / Surface
    public let background: Color
    public let surface: Color
    public let surfaceElevated: Color

    // Borders / Separators
    public let border: Color
    public let divider: Color

    // Actions
    public let actionPrimary: Color
    public let actionPrimaryPressed: Color
    public let actionPrimaryDisabled: Color
    public let actionOnPrimary: Color

    public let actionSecondary: Color
    public let actionSecondaryPressed: Color
    public let actionSecondaryDisabled: Color
    public let actionOnSecondary: Color

    // Feedback
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color

    public init(
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        textInverse: Color,
        background: Color,
        surface: Color,
        surfaceElevated: Color,
        border: Color,
        divider: Color,
        actionPrimary: Color,
        actionPrimaryPressed: Color,
        actionPrimaryDisabled: Color,
        actionOnPrimary: Color,
        actionSecondary: Color,
        actionSecondaryPressed: Color,
        actionSecondaryDisabled: Color,
        actionOnSecondary: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color
    ) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textInverse = textInverse
        self.background = background
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.border = border
        self.divider = divider
        self.actionPrimary = actionPrimary
        self.actionPrimaryPressed = actionPrimaryPressed
        self.actionPrimaryDisabled = actionPrimaryDisabled
        self.actionOnPrimary = actionOnPrimary
        self.actionSecondary = actionSecondary
        self.actionSecondaryPressed = actionSecondaryPressed
        self.actionSecondaryDisabled = actionSecondaryDisabled
        self.actionOnSecondary = actionOnSecondary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

public extension SemanticColors {
    /// Default semantic mapping for WPC.
    static let wpcDefault = SemanticColors(
        textPrimary: ColorTokens.gray900,
        textSecondary: ColorTokens.gray600,
        textTertiary: ColorTokens.gray500,
        textInverse: ColorTokens.white,

        background: ColorTokens.gray50,
        surface: ColorTokens.white,
        surfaceElevated: ColorTokens.white,

        border: ColorTokens.gray200,
        divider: ColorTokens.gray200,

        actionPrimary: ColorTokens.brand500,
        actionPrimaryPressed: ColorTokens.brand600,
        actionPrimaryDisabled: ColorTokens.gray300,
        actionOnPrimary: ColorTokens.white,

        actionSecondary: ColorTokens.gray100,
        actionSecondaryPressed: ColorTokens.gray200,
        actionSecondaryDisabled: ColorTokens.gray100,
        actionOnSecondary: ColorTokens.gray900,

        success: ColorTokens.success500,
        warning: ColorTokens.warning500,
        error: ColorTokens.error500,
        info: ColorTokens.info500
    )
}
