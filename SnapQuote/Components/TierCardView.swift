import SwiftUI

struct TierCardView: View {
    let tier: QuoteTier
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(tier.level.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.tierColor(for: tier.level))
                        .cornerRadius(4)

                    Spacer()

                    Text(tier.totalAmount.currencyString)
                        .font(.title3.bold())
                        .monospacedDigit()
                }

                if !tier.name.isEmpty {
                    Text(tier.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if !tier.tierDescription.isEmpty {
                    Text(tier.tierDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Text("\(tier.items.count) item\(tier.items.count == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.tierColor(for: tier.level).opacity(0.1) : Color.appCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.tierColor(for: tier.level) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
