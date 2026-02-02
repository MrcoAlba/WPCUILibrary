import SwiftUI

public enum WPCInputState: Sendable, Equatable {
    case normal
    case focused
    case disabled
    case error(message: String)

    public var isDisabled: Bool {
        if case .disabled = self { return true }
        return false
    }

    public var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}
