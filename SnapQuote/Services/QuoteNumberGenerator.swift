import Foundation

struct QuoteNumberGenerator {
    static func generate() -> String {
        let letters = String((0..<2).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()! })
        let numbers = String((0..<5).map { _ in "0123456789".randomElement()! })
        return "SQ-\(letters)\(numbers)"
    }
}
