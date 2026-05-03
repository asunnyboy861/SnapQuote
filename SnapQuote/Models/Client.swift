import Foundation
import SwiftData

@Model
final class Client {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String
    var phone: String
    var address: String
    var company: String
    var createdAt: Date
    var notes: String

    init(
        id: UUID = UUID(),
        name: String = "",
        email: String = "",
        phone: String = "",
        address: String = "",
        company: String = "",
        createdAt: Date = Date(),
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.company = company
        self.createdAt = createdAt
        self.notes = notes
    }
}
