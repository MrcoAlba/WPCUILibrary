import SwiftUI

public enum WPCButtonVariant: Sendable {
    case primary
    case secondary
    case tertiary
}

public enum WPCButtonSize: Sendable {
    case sm
    case md
    case lg
}

public struct WPCButtonStyle: ButtonStyle, Sendable {
    @Environment(\.wpcTheme) private var theme

    private let variant: WPCButtonVariant
    private let size: WPCButtonSize
    private let isFullWidth: Bool
    private let isLoading: Bool

    public init(
        variant: WPCButtonVariant = .primary,
        size: WPCButtonSize = .md,
        isFullWidth: Bool = true,
        isLoading: Bool = false
    ) {
        self.variant = variant
        self.size = size
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        let metrics = metricsForSize(size, theme: theme)
        let bg = backgroundColor(isPressed: configuration.isPressed)
        let fg = foregroundColor(isPressed: configuration.isPressed)
        let border = borderColor(isPressed: configuration.isPressed)

        return configuration.label
            .font(theme.typography.bodyStrong)
            .foregroundStyle(fg)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: metrics.height)
            .padding(.horizontal, metrics.horizontalPadding)
            .background(bg)
            .overlay(
                RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous)
                    .stroke(border, lineWidth: metrics.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))
            .opacity(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .contentShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))
            .overlay(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            // Si está loading, escondemos label visualmente pero mantenemos tamaño/layout
            .opacity(isLoading ? 0.92 : 1.0)
            .accessibilityAddTraits(.isButton)
    }

    // MARK: - Metrics

    private struct Metrics: Sendable {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
    }

    private func metricsForSize(_ size: WPCButtonSize, theme: Theme) -> Metrics {
        switch size {
        case .sm:
            return Metrics(height: 40, horizontalPadding: theme.spacing.lg, cornerRadius: theme.radius.md, borderWidth: 1)
        case .md:
            return Metrics(height: 48, horizontalPadding: theme.spacing.xl, cornerRadius: theme.radius.lg, borderWidth: 1)
        case .lg:
            return Metrics(height: 56, horizontalPadding: theme.spacing.xl, cornerRadius: theme.radius.xl, borderWidth: 1)
        }
    }

    // MARK: - Colors

    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return isPressed ? theme.colors.actionPrimaryPressed : theme.colors.actionPrimary
        case .secondary:
            return isPressed ? theme.colors.actionSecondaryPressed : theme.colors.actionSecondary
        case .tertiary:
            return .clear
        }
    }

    private func foregroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return theme.colors.actionOnPrimary
        case .secondary:
            return theme.colors.actionOnSecondary
        case .tertiary:
            return isPressed ? theme.colors.textPrimary : theme.colors.actionPrimary
        }
    }

    private func borderColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return .clear
        case .secondary:
            return theme.colors.border
        case .tertiary:
            return .clear
        }
    }
}
