import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PurchaseManager.self) private var purchaseManager
    @Query private var profiles: [BusinessProfile]
    @State private var profile = BusinessProfile()

    var body: some View {
        NavigationStack {
            Form {
                businessSection
                proSection
                policySection
                aboutSection
            }
            .navigationTitle("Settings")
            .onAppear {
                if let existing = profiles.first {
                    profile = existing
                }
            }
        }
    }

    private var businessSection: some View {
        Section("Business Profile") {
            TextField("Business Name", text: $profile.businessName)
            TextField("Email", text: $profile.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            TextField("Phone", text: $profile.phone)
                .keyboardType(.phonePad)
            TextField("Address", text: $profile.address)
            TextField("Website", text: $profile.website)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
            TextField("License #", text: $profile.licenseNumber)
            HStack {
                Text("Default Tax Rate")
                Spacer()
                TextField("0", value: $profile.taxRate, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("%")
            }
        }
        .onDisappear {
            if profiles.isEmpty {
                modelContext.insert(profile)
            }
        }
    }

    private var proSection: some View {
        Section("Pro") {
            if purchaseManager.isProUnlocked {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Pro Unlocked")
                        .foregroundColor(.green)
                }
            } else {
                NavigationLink(destination: PaywallView()) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.orange)
                        Text("Upgrade to Pro")
                            .foregroundColor(.orange)
                    }
                }
            }

            Button(action: {
                Task { await purchaseManager.restorePurchases() }
            }) {
                Text("Restore Purchases")
            }
        }
    }

    private var policySection: some View {
        Section("Legal") {
            Link("Support", destination: URL(string: "https://asunnyboy861.github.io/SnapQuote/support.html")!)
            Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/SnapQuote/privacy.html")!)
            Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/SnapQuote/terms.html")!)
            NavigationLink("Contact Support") {
                ContactSupportView()
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundColor(.secondary)
            }
        }
    }
}
