import SwiftUI
import UIKit

public struct WPCSearchField: View {
    @Environment(\.wpcTheme) private var theme
    @FocusState private var isFocused: Bool

    private let placeholder: String
    @Binding private var query: String

    private let state: WPCInputState
    private let style: WPCInputStyle
    private let submitLabel: SubmitLabel?
    private let onSubmit: (() -> Void)?
    private let onClear: (() -> Void)?

    public init(
        placeholder: String = "Buscar",
        query: Binding<String>,
        state: WPCInputState = .normal,
        style: WPCInputStyle = .default,
        submitLabel: SubmitLabel? = .search,
        onSubmit: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._query = query
        self.state = state
        self.style = style
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
        self.onClear = onClear
    }

    public var body: some View {
        let effectiveState = resolveState()

        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(theme.colors.textTertiary)
                .accessibilityHidden(true)

            TextField(placeholder, text: $query)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textPrimary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.default)
                .textContentType(nil)
                .disabled(effectiveState.isDisabled)
                .focused($isFocused)
                .applySubmit(submitLabel: submitLabel, onSubmit: onSubmit)

            if !query.isEmpty, !effectiveState.isDisabled {
                Button {
                    query = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(theme.colors.textTertiary)
                        .accessibilityHidden(true)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Borrar búsqueda")
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
        .accessibilityLabel("Búsqueda")
        .accessibilityValue(query)
        .accessibilityHint(accessibilityHint(for: effectiveState))
        .accessibilityAddTraits(.isSearchField)
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
