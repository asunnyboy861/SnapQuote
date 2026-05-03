import Foundation
import SwiftData

enum QuoteStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case sent = "Sent"
    case viewed = "Viewed"
    case accepted = "Accepted"
    case declined = "Declined"
    case expired = "Expired"
}

enum TierLevel: String, Codable, CaseIterable {
    case good = "Good"
    case better = "Better"
    case best = "Best"
}

@Model
final class Quote {
    @Attribute(.unique) var id: UUID
    var number: String
    var createdAt: Date
    var validUntil: Date
    var status: QuoteStatus
    var clientName: String
    var clientEmail: String
    var clientPhone: String
    var clientAddress: String
    var projectName: String
    var notes: String
    var taxRate: Double
    var discountRate: Double
    var signatureData: Data?
    var signedAt: Date?
    var signedByName: String?
    var businessName: String
    var businessEmail: String
    var businessPhone: String
    var businessAddress: String
    var logoData: Data?

    @Relationship(deleteRule: .cascade, inverse: \QuoteTier.quote) var tiers: [QuoteTier]

    var highestTotal: Double {
        tiers.map { $0.totalAmount }.max() ?? 0
    }

    var lowestTotal: Double {
        tiers.map { $0.totalAmount }.min() ?? 0
    }

    init(
        id: UUID = UUID(),
        number: String = "",
        createdAt: Date = Date(),
        validUntil: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        status: QuoteStatus = .draft,
        clientName: String = "",
        clientEmail: String = "",
        clientPhone: String = "",
        clientAddress: String = "",
        projectName: String = "",
        notes: String = "",
        taxRate: Double = 0,
        discountRate: Double = 0,
        signatureData: Data? = nil,
        signedAt: Date? = nil,
        signedByName: String? = nil,
        businessName: String = "",
        businessEmail: String = "",
        businessPhone: String = "",
        businessAddress: String = "",
        logoData: Data? = nil,
        tiers: [QuoteTier] = []
    ) {
        self.id = id
        self.number = number
        self.createdAt = createdAt
        self.validUntil = validUntil
        self.status = status
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientPhone = clientPhone
        self.clientAddress = clientAddress
        self.projectName = projectName
        self.notes = notes
        self.taxRate = taxRate
        self.discountRate = discountRate
        self.signatureData = signatureData
        self.signedAt = signedAt
        self.signedByName = signedByName
        self.businessName = businessName
        self.businessEmail = businessEmail
        self.businessPhone = businessPhone
        self.businessAddress = businessAddress
        self.logoData = logoData
        self.tiers = tiers
    }
}
