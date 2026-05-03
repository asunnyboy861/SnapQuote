import SwiftUI

struct ItemRowView: View {
    let item: QuoteItem
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name.isEmpty ? "Untitled Item" : item.name)
                    .font(.body.bold())
                if !item.itemDescription.isEmpty {
                    Text(item.itemDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(item.totalPrice.currencyString)
                    .font(.body.bold())
                    .monospacedDigit()
                Text("\(String(format: item.quantity == floor(item.quantity) ? "%.0f" : "%.1f", item.quantity)) \(item.unit) x \(item.unitPrice.currencyString)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture { onEdit?() }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) { onDelete?() } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
