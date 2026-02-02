import SwiftUI

/// Raw typography tokens (sizes, weights, line spacing).
public enum TypographyTokens {
    // Sizes
    public static let sizeXS: CGFloat = 12
    public static let sizeSM: CGFloat = 14
    public static let sizeMD: CGFloat = 16
    public static let sizeLG: CGFloat = 18
    public static let sizeXL: CGFloat = 20
    public static let size2XL: CGFloat = 24
    public static let size3XL: CGFloat = 30

    // Weights
    public static let regular: Font.Weight = .regular
    public static let medium: Font.Weight = .medium
    public static let semibold: Font.Weight = .semibold
    public static let bold: Font.Weight = .bold

    // Line spacing (baseline suggestions)
    public static let lineSpacingTight: CGFloat = 2
    public static let lineSpacingNormal: CGFloat = 4
    public static let lineSpacingRelaxed: CGFloat = 6
}
