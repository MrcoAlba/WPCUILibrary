import Foundation

/// Spacing scale for consistent layout across components.
/// Using Double keeps Tokens lightweight; components can cast to CGFloat as needed.
public enum SpacingTokens {
    public static let xxs: CGFloat = 2
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 40
}
