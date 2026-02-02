import SwiftUI
import UIKit

public struct WPCTextArea: View {
    @Environment(\.wpcTheme) private var theme
    @FocusState private var isFocused: Bool

    private let title: String?
    private let placeholder: String
    @Binding private var text: String

    private let helperText: String?
    private let state: WPCInputState
    private let style: WPCInputStyle

    private let minLines: Int
    private let maxLines: Int
    private let maxLength: Int?

    private let submitLabel: SubmitLabel?
    private let onSubmit: (() -> Void)?

    public init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        helperText: String? = nil,
        state: WPCInputState = .normal,
        style: WPCInputStyle = .default,
        minLines: Int = 3,
        maxLines: Int = 6,
        maxLength: Int? = nil,
        submitLabel: SubmitLabel? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
        self.state = state
        self.style = style
        self.minLines = max(1, minLines)
        self.maxLines = max(self.minLines, maxLines)
        self.maxLength = maxLength
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }

    public var body: some View {
        let effectiveState = resolvedState

        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            titleView

            textAreaContainer(effectiveState: effectiveState)

            footerRow(effectiveState: effectiveState)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title ?? placeholder)
        .accessibilityValue(text)
        .accessibilityHint(accessibilityHint(for: effectiveState))
    }

    // MARK: - Subviews (split to help compiler)

    @ViewBuilder
    private var titleView: some View {
        if let title, !title.isEmpty {
            Text(title)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.textSecondary)
        }
    }

    private func textAreaContainer(effectiveState: WPCInputState) -> some View {
        ZStack(alignment: .topLeading) {
            placeholderView

            textAreaField(effectiveState: effectiveState)
        }
        .frame(minHeight: minHeight)
        .background(theme.colors.surface)
        .overlay(border(effectiveState: effectiveState))
        .clipShape(clipShape)
        .opacity(effectiveState.isDisabled ? 0.75 : 1.0)
    }

    @ViewBuilder
    private var placeholderView: some View {
        if text.isEmpty {
            Text(placeholder)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textTertiary)
                .padding(.horizontal, style.horizontalPadding)
                .padding(.vertical, style.verticalPadding)
                .accessibilityHidden(true)
        }
    }

    private func textAreaField(effectiveState: WPCInputState) -> some View {
        TextField("", text: $text, axis: .vertical)
            .font(theme.typography.body)
            .foregroundStyle(theme.colors.textPrimary)
            .textInputAutocapitalization(.sentences)
            .autocorrectionDisabled(false)
            .disabled(effectiveState.isDisabled)
            .focused($isFocused)
            .lineLimit(minLines...maxLines)
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .applySubmit(submitLabel: submitLabel, onSubmit: onSubmit)
            .onChange(of: text) { _, newValue in
                guard let maxLength else { return }
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
    }

    private func footerRow(effectiveState: WPCInputState) -> some View {
        HStack {
            footer(for: effectiveState)
            Spacer()
            counterView
        }
    }

    @ViewBuilder
    private var counterView: some View {
        if let maxLength {
            Text("\(text.count)/\(maxLength)")
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.textTertiary)
        }
    }

    private func border(effectiveState: WPCInputState) -> some View {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
            .stroke(borderColor(for: effectiveState), lineWidth: style.borderWidth)
    }

    private var clipShape: some Shape {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
    }

    private var minHeight: CGFloat {
        // 22 aprox por línea (depende font), pero suficiente para layout inicial
        CGFloat(minLines) * 22 + style.verticalPadding * 2
    }

    // MARK: - Footer (unchanged)

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

    // MARK: - State & Colors

    private var resolvedState: WPCInputState {
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
