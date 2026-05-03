import Foundation
import SwiftData

@Model
final class QuoteItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String
    var quantity: Double
    var unit: String
    var unitPrice: Double
    var category: String
    var sortOrder: Int

    var totalPrice: Double {
        quantity * unitPrice
    }

    var tier: QuoteTier?

    init(
        id: UUID = UUID(),
        name: String = "",
        itemDescription: String = "",
        quantity: Double = 1,
        unit: String = "ea",
        unitPrice: Double = 0,
        category: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.quantity = quantity
        self.unit = unit
        self.unitPrice = unitPrice
        self.category = category
        self.sortOrder = sortOrder
    }
}
