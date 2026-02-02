import SwiftUI
import UIKit

public struct WPCOTPField: View {
    @Environment(\.wpcTheme) private var theme

    private let length: Int
    @Binding private var code: String

    private let state: WPCInputState
    private let cellSize: CGFloat
    private let cellCornerRadius: CGFloat
    private let spacing: CGFloat
    private let onComplete: ((String) -> Void)?

    @State private var digits: [String]
    @FocusState private var focusedIndex: Int?

    public init(
        length: Int = 6,
        code: Binding<String>,
        state: WPCInputState = .normal,
        cellSize: CGFloat = 44,
        cellCornerRadius: CGFloat = 12,
        spacing: CGFloat = 10,
        onComplete: ((String) -> Void)? = nil
    ) {
        self.length = max(1, length)
        self._code = code
        self.state = state
        self.cellSize = cellSize
        self.cellCornerRadius = cellCornerRadius
        self.spacing = spacing
        self.onComplete = onComplete
        self._digits = State(initialValue: Array(repeating: "", count: max(1, length)))
    }

    public var body: some View {
        let effectiveState = state

        HStack(spacing: spacing) {
            ForEach(0..<length, id: \.self) { index in
                TextField("", text: bindingForDigit(index))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .multilineTextAlignment(.center)
                    .font(theme.typography.bodyStrong)
                    .frame(width: cellSize, height: cellSize)
                    .background(theme.colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous)
                            .stroke(cellBorderColor(index: index, state: effectiveState), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous))
                    .focused($focusedIndex, equals: index)
                    .disabled(effectiveState.isDisabled)
                    .onChange(of: digits[index]) { _, newValue in
                        handleChange(at: index, newValue: newValue)
                    }
                    .accessibilityLabel("Dígito \(index + 1) de \(length)")
            }
        }
        .onAppear {
            syncFromCode()
        }
        .onChange(of: code) { _, _ in
            syncFromCode()
        }
        .accessibilityHint(effectiveState.isDisabled ? "Campo deshabilitado" : "")
    }

    private func bindingForDigit(_ index: Int) -> Binding<String> {
        Binding(
            get: { digits[safe: index] ?? "" },
            set: { newValue in
                digits[index] = newValue
            }
        )
    }

    private func handleChange(at index: Int, newValue: String) {
        guard !state.isDisabled else { return }

        // Keep only digits
        let filtered = newValue.filter { $0.isNumber }

        if filtered.count <= 1 {
            digits[index] = filtered
        } else {
            // Paste case: distribute
            let chars = Array(filtered.prefix(length - index))
            for (offset, ch) in chars.enumerated() {
                digits[index + offset] = String(ch)
            }
        }

        // Move focus
        if digits[index].count == 1 {
            if index < length - 1 {
                focusedIndex = index + 1
            } else {
                focusedIndex = nil
            }
        } else if digits[index].isEmpty {
            if index > 0 { focusedIndex = index - 1 }
        }

        // Update bound code
        let joined = digits.joined()
        code = joined

        if joined.count == length {
            onComplete?(joined)
        }
    }

    private func syncFromCode() {
        let filtered = code.filter { $0.isNumber }
        let chars = Array(filtered.prefix(length))
        var next = Array(repeating: "", count: length)
        for i in 0..<chars.count {
            next[i] = String(chars[i])
        }
        digits = next
    }

    private func cellBorderColor(index: Int, state: WPCInputState) -> Color {
        if case .error = state { return theme.colors.error }
        if focusedIndex == index { return theme.colors.actionPrimary }
        return theme.colors.border
    }
}

private extension Array where Element == String {
    subscript(safe index: Int) -> String? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}
