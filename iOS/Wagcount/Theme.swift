import SwiftUI

/// Unique visual identity for Wagcount.
enum Theme {
    static let background = Color(red: 0.078, green: 0.125, blue: 0.086)
    static let accent = Color(red: 0.424, green: 0.796, blue: 0.373)
    static let secondary = Color(red: 0.663, green: 0.851, blue: 0.627)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
