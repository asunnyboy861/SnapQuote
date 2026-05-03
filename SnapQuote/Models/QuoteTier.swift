import Foundation
import SwiftData

@Model
final class QuoteTier {
    @Attribute(.unique) var id: UUID
    var level: TierLevel
    var name: String
    var tierDescription: String
    var colorHex: String
    var sortOrder: Int

    @Relationship(deleteRule: .cascade, inverse: \QuoteItem.tier) var items: [QuoteItem]
    var quote: Quote?

    var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    var taxAmount: Double {
        guard let quote = quote else { return 0 }
        return subtotal * quote.taxRate / 100
    }

    var discountAmount: Double {
        guard let quote = quote else { return 0 }
        return subtotal * quote.discountRate / 100
    }

    var totalAmount: Double {
        subtotal + taxAmount - discountAmount
    }

    init(
        id: UUID = UUID(),
        level: TierLevel = .good,
        name: String = "",
        tierDescription: String = "",
        colorHex: String = "#34C759",
        sortOrder: Int = 0,
        items: [QuoteItem] = []
    ) {
        self.id = id
        self.level = level
        self.name = name
        self.tierDescription = tierDescription
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.items = items
    }
}
