import Foundation

extension Date {
    func formatted(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }

    var shortDate: String {
        formatted(dateStyle: .short)
    }

    var mediumDate: String {
        formatted(dateStyle: .medium)
    }

    var isValid: Bool {
        self > Date()
    }
}
