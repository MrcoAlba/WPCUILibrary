import SwiftUI
import UIKit

public struct WPCSecureField: View {
    @Environment(\.wpcTheme) private var theme
    @FocusState private var isFocused: Bool

    private let title: String?
    private let placeholder: String
    @Binding private var text: String

    private let helperText: String?
    private let state: WPCInputState
    private let style: WPCInputStyle

    private let textContentType: UITextContentType?
    private let submitLabel: SubmitLabel?
    private let onSubmit: (() -> Void)?

    private let isRevealable: Bool
    @State private var isRevealed: Bool = false

    public init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        helperText: String? = nil,
        state: WPCInputState = .normal,
        style: WPCInputStyle = .default,
        textContentType: UITextContentType? = .password,
        submitLabel: SubmitLabel? = nil,
        onSubmit: (() -> Void)? = nil,
        isRevealable: Bool = true
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
        self.state = state
        self.style = style
        self.textContentType = textContentType
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
        self.isRevealable = isRevealable
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
                Group {
                    if isRevealable, isRevealed {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textPrimary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.default)
                .textContentType(textContentType)
                .disabled(effectiveState.isDisabled)
                .focused($isFocused)
                .applySubmit(submitLabel: submitLabel, onSubmit: onSubmit)

                if isRevealable {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(theme.colors.textTertiary)
                            .accessibilityHidden(true)
                    }
                    .buttonStyle(.plain)
                    .disabled(effectiveState.isDisabled)
                    .accessibilityLabel(isRevealed ? "Ocultar contraseña" : "Mostrar contraseña")
                }
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
        .accessibilityValue(text.isEmpty ? "" : "••••")
        .accessibilityHint(accessibilityHint(for: effectiveState))
        .accessibilityAddTraits(.isSearchField)
    }

    @ViewBuilder
    private func footer(for state: WPCInputState) -> some View {
        if let msg = state.errorMessage {
            Text(msg)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.error)
        } else if let helperText, !helperText.isEmpty {
            Text(helperText)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.textTertiary)
        }
    }

    private func resolveState() -> WPCInputState {
        switch state {
        case .disabled: return .disabled
        case .error: return state
        case .focused: return .focused
        case .normal: return isFocused ? .focused : .normal
        }
    }

    private func borderColor(for state: WPCInputState) -> Color {
        switch state {
        case .normal: return theme.colors.border
        case .focused: return theme.colors.actionPrimary
        case .disabled: return theme.colors.divider
        case .error: return theme.colors.error
        }
    }

    private func accessibilityHint(for state: WPCInputState) -> String {
        switch state {
        case .error(let message): return message
        case .disabled: return "Campo deshabilitado"
        default: return ""
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
