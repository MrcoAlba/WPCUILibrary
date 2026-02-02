import SwiftUI
import UIKit

public struct WPCPhoneField: View {
    @Environment(\.wpcTheme) private var theme
    @FocusState private var isFocused: Bool

    private let title: String?
    private let placeholder: String
    @Binding private var phone: String

    private let helperText: String?
    private let state: WPCInputState
    private let style: WPCInputStyle

    private let countryPrefix: String?     // ej "+51"
    private let maxDigits: Int             // sin contar prefix
    private let submitLabel: SubmitLabel?
    private let onSubmit: (() -> Void)?

    public init(
        title: String? = nil,
        placeholder: String = "Número de teléfono",
        phone: Binding<String>,
        helperText: String? = nil,
        state: WPCInputState = .normal,
        style: WPCInputStyle = .default,
        countryPrefix: String? = nil,
        maxDigits: Int = 15,
        submitLabel: SubmitLabel? = .done,
        onSubmit: (() -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._phone = phone
        self.helperText = helperText
        self.state = state
        self.style = style
        self.countryPrefix = countryPrefix
        self.maxDigits = max(1, maxDigits)
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
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
                if let countryPrefix {
                    Text(countryPrefix)
                        .font(theme.typography.bodyStrong)
                        .foregroundStyle(theme.colors.textSecondary)
                        .accessibilityHidden(true)
                }

                TextField(placeholder, text: $phone)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.textPrimary)
                    .keyboardType(.phonePad)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.telephoneNumber)
                    .disabled(effectiveState.isDisabled)
                    .focused($isFocused)
                    .applySubmit(submitLabel: submitLabel, onSubmit: onSubmit)
                    .onChange(of: phone) { _, newValue in
                        guard !effectiveState.isDisabled else { return }
                        phone = formatPhone(newValue)
                    }

                if !phone.isEmpty, !effectiveState.isDisabled {
                    Button { phone = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.colors.textTertiary)
                            .accessibilityHidden(true)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Borrar teléfono")
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
        .accessibilityValue(phone)
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

    private func formatPhone(_ input: String) -> String {
        // Mantén solo dígitos, limita longitud, y aplica un formateo simple por grupos (3-3-...).
        let digits = input.filter { $0.isNumber }
        let trimmed = String(digits.prefix(maxDigits))

        // Formato simple: 3-3-3-... (puedes adaptar por país después)
        var result = ""
        for (i, ch) in trimmed.enumerated() {
            if i != 0, i % 3 == 0 { result.append(" ") }
            result.append(ch)
        }
        return result
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
