import SwiftUI

/// Minimal shadow recipe token.
/// (We keep it simple; we can evolve it later with multiple shadow layers if needed.)
public struct ElevationToken: Sendable {
    public let radius: Double
    public let x: Double
    public let y: Double
    public let opacity: Double

    public init(radius: Double, x: Double, y: Double, opacity: Double) {
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
    }
}

public enum ElevationTokens {
    public static let none = ElevationToken(radius: 0, x: 0, y: 0, opacity: 0)
    public static let sm   = ElevationToken(radius: 6,  x: 0, y: 2,  opacity: 0.08)
    public static let md   = ElevationToken(radius: 10, x: 0, y: 6,  opacity: 0.12)
    public static let lg   = ElevationToken(radius: 16, x: 0, y: 10, opacity: 0.16)
}

public extension View {
    /// Applies elevation shadow based on token.
    func wpcElevation(_ token: ElevationToken) -> some View {
        shadow(
            color: Color.black.opacity(token.opacity),
            radius: token.radius,
            x: token.x,
            y: token.y
        )
    }
}
