import SwiftUI

public struct WPCInputStyle: Sendable {
    public var height: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat

    public init(
        height: CGFloat = 48,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 8,
        cornerRadius: CGFloat = 18,
        borderWidth: CGFloat = 1
    ) {
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }

    public static let `default` = WPCInputStyle()
}

#Preview("WPCInputStyle Preview") {
    @Previewable @State var text: String = ""
    VStack(alignment: .leading, spacing: 8) {
        Text("WPCInputStyle preview")
            .font(.headline)
        Text("height: \(WPCInputStyle.default.height)")
        Text("horizontalPadding: \(WPCInputStyle.default.horizontalPadding)")
        Text("verticalPadding: \(WPCInputStyle.default.verticalPadding)")
        Text("cornerRadius: \(WPCInputStyle.default.cornerRadius)")
        Text("borderWidth: \(WPCInputStyle.default.borderWidth)")
        WPCTextField(title: "TextField", placeholder: "texto preview", text: $text)
        WPCTextField(title: "TextField", placeholder: "texto preview", text: $text)
    }
    .padding()
}
