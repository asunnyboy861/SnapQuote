import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    header
                    features
                    purchaseButton
                    restoreButton
                    terms
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .background(Color.appBackground)
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not Now") { dismiss() }
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Unlock SnapQuote Pro")
                .font(.title.bold())

            Text("One-time purchase. No subscription. Ever.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }

    private var features: some View {
        VStack(spacing: 16) {
            FeatureRow(icon: "infinity", title: "Unlimited Estimates", description: "Create as many estimates as you need")
            FeatureRow(icon: "square.3.layers.3d", title: "Good/Better/Best Tiers", description: "The #1 sales strategy for contractors")
            FeatureRow(icon: "pencil.tip", title: "Signature Capture", description: "Get client signatures on-site")
            FeatureRow(icon: "doc.richtext", title: "Branded PDFs", description: "Professional estimates with your logo")
            FeatureRow(icon: "person.2", title: "Client Management", description: "Organize all your clients in one place")
            FeatureRow(icon: "archivebox", title: "Product Library", description: "Save and reuse your common items")
            FeatureRow(icon: "icloud", title: "iCloud Sync", description: "Sync across all your devices")
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(16)
    }

    private var purchaseButton: some View {
        Button(action: performPurchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Unlock Pro — $14.99")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isPurchasing)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task { await purchaseManager.restorePurchases() }
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }

    private var terms: some View {
        VStack(spacing: 4) {
            Text("One-time purchase. No recurring charges.")
                .font(.caption2)
                .foregroundColor(.secondary)
            Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/SnapQuote/terms.html")!)
                .font(.caption2)
        }
    }

    private func performPurchase() {
        isPurchasing = true
        Task {
            let success = await purchaseManager.purchase()
            isPurchasing = false
            if success {
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold())
                Text(description).font(.caption).foregroundColor(.secondary)
            }
        }
    }
}
