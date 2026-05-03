import Foundation
import SwiftData

@Model
final class BusinessProfile {
    @Attribute(.unique) var id: UUID
    var businessName: String
    var email: String
    var phone: String
    var address: String
    var website: String
    var licenseNumber: String
    var taxRate: Double
    var logoData: Data?

    init(
        id: UUID = UUID(),
        businessName: String = "",
        email: String = "",
        phone: String = "",
        address: String = "",
        website: String = "",
        licenseNumber: String = "",
        taxRate: Double = 0,
        logoData: Data? = nil
    ) {
        self.id = id
        self.businessName = businessName
        self.email = email
        self.phone = phone
        self.address = address
        self.website = website
        self.licenseNumber = licenseNumber
        self.taxRate = taxRate
        self.logoData = logoData
    }
}
