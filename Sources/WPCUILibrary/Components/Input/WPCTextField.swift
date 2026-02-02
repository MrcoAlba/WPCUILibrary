import SwiftUI
import UIKit

public struct WPCTextField: View {
    @Environment(\.wpcTheme) private var theme
    @FocusState private var isFocused: Bool

    private let title: String?
    private let placeholder: String
    @Binding private var text: String

    private let helperText: String?
    private let state: WPCInputState
    private let style: WPCInputStyle

    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrectionDisabled: Bool
    private let submitLabel: SubmitLabel?
    private let onSubmit: (() -> Void)?

    private let leftSystemImage: String?
    private let rightSystemImage: String?
    private let onTapRightIcon: (() -> Void)?
    private let showsClearButton: Bool

    public init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        helperText: String? = nil,
        state: WPCInputState = .normal,
        style: WPCInputStyle = .default,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        submitLabel: SubmitLabel? = nil,
        onSubmit: (() -> Void)? = nil,
        leftSystemImage: String? = nil,
        rightSystemImage: String? = nil,
        onTapRightIcon: (() -> Void)? = nil,
        showsClearButton: Bool = true
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
        self.state = state
        self.style = style
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
        self.leftSystemImage = leftSystemImage
        self.rightSystemImage = rightSystemImage
        self.onTapRightIcon = onTapRightIcon
        self.showsClearButton = showsClearButton
    }

    public var body: some View {
        let effectiveState = resolveState()

        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            if let title, !title.isEmpty {
                Text(title)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.textSecondary)
            }

            HStack(spacing: theme.spacing.sm) {
                if let leftSystemImage {
                    Image(systemName: leftSystemImage)
                        .foregroundStyle(theme.colors.textTertiary)
                        .accessibilityHidden(true)
                }

                TextField(placeholder, text: $text)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.textPrimary)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .disabled(effectiveState.isDisabled)
                    .focused($isFocused)
                    .applySubmit(submitLabel: submitLabel, onSubmit: onSubmit)

                trailingView(for: effectiveState)
            }
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .frame(minHeight: style.height)
            .background(theme.colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .stroke(borderColor(for: effectiveState), lineWidth: style.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
            .opacity(effectiveState.isDisabled ? 0.75 : 1.0)

            footer(for: effectiveState)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title ?? placeholder)
        .accessibilityValue(text)
        .accessibilityHint(accessibilityHint(for: effectiveState))
        .accessibilityAddTraits(.isSearchField)
        .onChange(of: isFocused) { _, newValue in
            // Si el consumidor manda state = .focused explícito, lo respetamos.
            // Si state = normal/error/disabled, el focus solo afecta el "resolveState".
            _ = newValue
        }
    }

    @ViewBuilder
    private func trailingView(for state: WPCInputState) -> some View {
        if shouldShowClearButton(state: state) {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(theme.colors.textTertiary)
                    .accessibilityHidden(true)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .accessibilityLabel("Borrar texto")
        } else if let rightSystemImage {
            Button {
                onTapRightIcon?()
            } label: {
                Image(systemName: rightSystemImage)
                    .foregroundStyle(theme.colors.textTertiary)
                    .accessibilityHidden(true)
            }
            .buttonStyle(.plain)
            .disabled(onTapRightIcon == nil || state.isDisabled)
            .accessibilityLabel("Acción")
        }
    }

    @ViewBuilder
    private func footer(for state: WPCInputState) -> some View {
        if let msg = state.errorMessage {
            Text(msg)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.error)
                .accessibilityLabel("Error: \(msg)")
        } else if let helperText, !helperText.isEmpty {
            Text(helperText)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.textTertiary)
        }
    }

    private func resolveState() -> WPCInputState {
        switch state {
        case .disabled:
            return .disabled
        case .error:
            return state
        case .focused:
            return .focused
        case .normal:
            return isFocused ? .focused : .normal
        }
    }

    private func borderColor(for state: WPCInputState) -> Color {
        switch state {
        case .normal:
            return theme.colors.border
        case .focused:
            return theme.colors.actionPrimary
        case .disabled:
            return theme.colors.divider
        case .error:
            return theme.colors.error
        }
    }

    private func shouldShowClearButton(state: WPCInputState) -> Bool {
        guard showsClearButton else { return false }
        guard !state.isDisabled else { return false }
        guard !text.isEmpty else { return false }
        return true
    }

    private func accessibilityHint(for state: WPCInputState) -> String {
        switch state {
        case .error(let message):
            return message
        case .disabled:
            return "Campo deshabilitado"
        default:
            return ""
        }
    }
}

private extension View {
    @ViewBuilder
    func applySubmit(submitLabel: SubmitLabel?, onSubmit: (() -> Void)?) -> some View {
        if let submitLabel, let onSubmit {
            self.submitLabel(submitLabel).onSubmit(onSubmit)
        } else {
            self
        }
    }
}
