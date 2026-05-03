import Foundation
import SwiftData

@Model
final class ProductLibrary {
    @Attribute(.unique) var id: UUID
    var name: String
    var productDescription: String
    var category: String
    var defaultUnit: String
    var defaultUnitPrice: Double
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        productDescription: String = "",
        category: String = "",
        defaultUnit: String = "ea",
        defaultUnitPrice: Double = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.productDescription = productDescription
        self.category = category
        self.defaultUnit = defaultUnit
        self.defaultUnitPrice = defaultUnitPrice
        self.createdAt = createdAt
    }
}
