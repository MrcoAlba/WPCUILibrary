import SwiftUI

/// Raw palette tokens (non-semantic).
/// Components should NOT depend on these directly; use `SemanticColors` instead.
public enum ColorTokens {
    // Basics
    public static let white: Color = .white
    public static let black: Color = .black

    // Neutral scale
    public static let gray50  = Color(hex: "#FAFAFA")
    public static let gray100 = Color(hex: "#F5F6F7")
    public static let gray200 = Color(hex: "#E6E8EB")
    public static let gray300 = Color(hex: "#D0D5DD")
    public static let gray400 = Color(hex: "#98A2B3")
    public static let gray500 = Color(hex: "#667085")
    public static let gray600 = Color(hex: "#475467")
    public static let gray700 = Color(hex: "#344054")
    public static let gray800 = Color(hex: "#1D2939")
    public static let gray900 = Color(hex: "#101828")

    // Brand (WPC baseline)
    public static let brand50  = Color(hex: "#EEF4FF")
    public static let brand100 = Color(hex: "#D9E6FF")
    public static let brand200 = Color(hex: "#B4CCFF")
    public static let brand300 = Color(hex: "#84ADFF")
    public static let brand400 = Color(hex: "#528BFF")
    public static let brand500 = Color(hex: "#2E6BFF") // Primary
    public static let brand600 = Color(hex: "#1F4FE0")
    public static let brand700 = Color(hex: "#173DB0")
    public static let brand800 = Color(hex: "#112F86")
    public static let brand900 = Color(hex: "#0C215F")

    // Feedback
    public static let success50  = Color(hex: "#ECFDF3")
    public static let success500 = Color(hex: "#12B76A")

    public static let warning50  = Color(hex: "#FFFAEB")
    public static let warning500 = Color(hex: "#F79009")

    public static let error50    = Color(hex: "#FEF3F2")
    public static let error500   = Color(hex: "#F04438")

    public static let info50     = Color(hex: "#EFF8FF")
    public static let info500    = Color(hex: "#2E90FA")
}

// MARK: - Hex helper kept near Tokens to avoid cross-module dependency early.
public extension Color {
    /// Creates a SwiftUI Color from a hex string like "#RRGGBB" or "RRGGBB".
    /// If the input is invalid, it falls back to black.
    init(hex: String, alpha: Double = 1.0) {
        let cleaned = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        guard cleaned.count == 6 else {
            self = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: alpha)
            return
        }

        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
