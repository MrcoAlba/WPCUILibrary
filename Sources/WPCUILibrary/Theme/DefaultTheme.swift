import SwiftUI

/// Public entry point for the default WPC theme.
/// Mantiene el archivo simple para que cualquier app pueda usar:
/// `.wpcTheme(.wpcDefault)` o inyectar un theme alternativo.
public struct DefaultTheme {
    /// El tema por defecto del design system.
    public static let current: Theme = .wpcDefault
}
