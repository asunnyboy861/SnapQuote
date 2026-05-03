import SwiftUI
import PDFKit

struct PDFGenerator {
    @MainActor
    static func generate(quote: Quote) -> Data? {
        let renderer = ImageRenderer(content: QuotePDFView(quote: quote))
        renderer.scale = 2.0

        guard let uiImage = renderer.uiImage else { return nil }

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: CGSize(width: 612, height: 792)), nil)
        UIGraphicsBeginPDFPage()
        uiImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 612, height: 792)))
        UIGraphicsEndPDFContext()

        return pdfData as Data
    }
}

struct QuotePDFView: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            Divider()
            clientInfo
            Divider()
            tiersSection
            Divider()
            footer
        }
        .padding(40)
        .frame(width: 612, alignment: .leading)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(quote.businessName.isEmpty ? "Your Business" : quote.businessName)
                    .font(.title.bold())
                if !quote.businessEmail.isEmpty {
                    Text(quote.businessEmail).font(.caption).foregroundColor(.secondary)
                }
                if !quote.businessPhone.isEmpty {
                    Text(quote.businessPhone).font(.caption).foregroundColor(.secondary)
                }
                if !quote.businessAddress.isEmpty {
                    Text(quote.businessAddress).font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("ESTIMATE").font(.title2.bold()).foregroundColor(.blue)
                Text(quote.number).font(.headline)
                Text("Date: \(quote.createdAt.mediumDate)").font(.caption)
                Text("Valid Until: \(quote.validUntil.mediumDate)").font(.caption)
            }
        }
    }

    private var clientInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Prepared For").font(.headline)
            Text(quote.clientName.isEmpty ? "Client Name" : quote.clientName).font(.body)
            if !quote.clientEmail.isEmpty { Text(quote.clientEmail).font(.caption) }
            if !quote.clientPhone.isEmpty { Text(quote.clientPhone).font(.caption) }
            if !quote.clientAddress.isEmpty { Text(quote.clientAddress).font(.caption) }
            if !quote.projectName.isEmpty {
                Text("Project: \(quote.projectName)").font(.caption).padding(.top, 4)
            }
        }
    }

    private var tiersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(quote.tiers.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { tier in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(tier.level.rawValue.uppercased())
                            .font(.headline)
                            .foregroundColor(Color.tierColor(for: tier.level))
                        if !tier.name.isEmpty {
                            Text("- \(tier.name)").font(.subheadline)
                        }
                        Spacer()
                        Text(tier.totalAmount.currencyString)
                            .font(.title3.bold())
                    }

                    if !tier.tierDescription.isEmpty {
                        Text(tier.tierDescription).font(.caption).foregroundColor(.secondary)
                    }

                    ForEach(tier.items.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("\(String(format: "%.0f", item.quantity)) \(item.unit)")
                            Text("x")
                            Text(item.unitPrice.currencyString)
                            Text("=")
                            Text(item.totalPrice.currencyString).bold()
                        }
                        .font(.caption)
                    }

                    if quote.taxRate > 0 {
                        HStack {
                            Spacer()
                            Text("Subtotal: \(tier.subtotal.currencyString)")
                            Text("Tax (\(quote.taxRate.percentString)): \(tier.taxAmount.currencyString)")
                        }.font(.caption2).foregroundColor(.secondary)
                    }

                    if quote.discountRate > 0 {
                        HStack {
                            Spacer()
                            Text("Discount (\(quote.discountRate.percentString)): -\(tier.discountAmount.currencyString)")
                        }.font(.caption2).foregroundColor(.secondary)
                    }
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.tierColor(for: tier.level), lineWidth: 2)
                )
            }
        }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !quote.notes.isEmpty {
                Text("Notes").font(.headline)
                Text(quote.notes).font(.caption)
            }
            if quote.signatureData != nil {
                Text("Signature").font(.headline)
                if let sigData = quote.signatureData,
                   let uiImage = UIImage(data: sigData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 80)
                }
                if let signedAt = quote.signedAt {
                    Text("Signed: \(signedAt.mediumDate)").font(.caption2)
                }
            }
        }
    }
}
