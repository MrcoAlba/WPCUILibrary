import SwiftUI

/// Semantic font styles: UI components should use these (not raw size tokens).
public struct FontStyles: Sendable {
    // Headings
    public let h1: Font
    public let h2: Font
    public let h3: Font

    // Body
    public let body: Font
    public let bodyStrong: Font
    public let caption: Font
    public let overline: Font

    public init(
        h1: Font,
        h2: Font,
        h3: Font,
        body: Font,
        bodyStrong: Font,
        caption: Font,
        overline: Font
    ) {
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.body = body
        self.bodyStrong = bodyStrong
        self.caption = caption
        self.overline = overline
    }
}

public extension FontStyles {
    /// Default semantic fonts (system fonts).
    static let wpcDefault = FontStyles(
        h1: .system(size: TypographyTokens.size3XL, weight: TypographyTokens.bold),
        h2: .system(size: TypographyTokens.size2XL, weight: TypographyTokens.semibold),
        h3: .system(size: TypographyTokens.sizeXL,  weight: TypographyTokens.semibold),
        body: .system(size: TypographyTokens.sizeMD, weight: TypographyTokens.regular),
        bodyStrong: .system(size: TypographyTokens.sizeMD, weight: TypographyTokens.semibold),
        caption: .system(size: TypographyTokens.sizeSM, weight: TypographyTokens.regular),
        overline: .system(size: TypographyTokens.sizeXS, weight: TypographyTokens.medium)
    )
}
