import SwiftUI

public struct WPCButton: View {
    @Environment(\.wpcTheme) private var theme

    private let title: String
    private let variant: WPCButtonVariant
    private let size: WPCButtonSize
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let isDisabled: Bool
    private let leadingSystemImage: String?
    private let trailingSystemImage: String?
    private let accessibilityLabel: String?
    private let action: () -> Void

    public init(
        _ title: String,
        variant: WPCButtonVariant = .primary,
        size: WPCButtonSize = .md,
        isFullWidth: Bool = true,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        leadingSystemImage: String? = nil,
        trailingSystemImage: String? = nil,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.leadingSystemImage = leadingSystemImage
        self.trailingSystemImage = trailingSystemImage
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        Button {
            guard !isDisabled && !isLoading else { return }
            action()
        } label: {
            HStack(spacing: theme.spacing.sm) {
                if let leadingSystemImage {
                    Image(systemName: leadingSystemImage)
                }

                Text(title)
                    .lineLimit(1)

                if let trailingSystemImage {
                    Image(systemName: trailingSystemImage)
                }
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .opacity(isLoading ? 0 : 1) // label invisible mientras ProgressView aparece
            .accessibilityLabel(accessibilityLabel ?? title)
        }
        .buttonStyle(
            WPCButtonStyle(
                variant: variant,
                size: size,
                isFullWidth: isFullWidth,
                isLoading: isLoading
            )
        )
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.65 : 1.0)
        .accessibilityHint(isLoading ? "Cargando" : "")
    }
}
