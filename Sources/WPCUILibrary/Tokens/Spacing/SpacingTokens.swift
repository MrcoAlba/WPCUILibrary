import Foundation

/// Spacing scale for consistent layout across components.
/// Using Double keeps Tokens lightweight; components can cast to CGFloat as needed.
public enum SpacingTokens {
    public static let xxs: Double = 2
    public static let xs: Double = 4
    public static let sm: Double = 8
    public static let md: Double = 12
    public static let lg: Double = 16
    public static let xl: Double = 24
    public static let xxl: Double = 32
    public static let xxxl: Double = 40
}
