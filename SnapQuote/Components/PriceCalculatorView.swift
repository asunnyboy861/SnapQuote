import SwiftUI

struct PriceCalculatorView: View {
    let subtotal: Double
    let taxRate: Double
    let discountRate: Double
    let taxAmount: Double
    let discountAmount: Double
    let total: Double

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Subtotal")
                Spacer()
                Text(subtotal.currencyString).monospacedDigit()
            }
            .font(.subheadline)

            if taxRate > 0 {
                HStack {
                    Text("Tax (\(taxRate.percentString))")
                    Spacer()
                    Text(taxAmount.currencyString).monospacedDigit()
                }
                .font(.subheadline).foregroundColor(.secondary)
            }

            if discountRate > 0 {
                HStack {
                    Text("Discount (\(discountRate.percentString))")
                    Spacer()
                    Text("-\(discountAmount.currencyString)").monospacedDigit()
                }
                .font(.subheadline).foregroundColor(.red)
            }

            Divider()

            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text(total.currencyString)
                    .font(.title3.bold())
                    .monospacedDigit()
            }
        }
        .padding(16)
        .background(Color.appCard)
        .cornerRadius(12)
    }
}
