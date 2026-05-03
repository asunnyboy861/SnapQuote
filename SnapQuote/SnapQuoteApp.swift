import SwiftUI
import SwiftData

@main
struct SnapQuoteApp: App {
    @State private var purchaseManager = PurchaseManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environment(purchaseManager)
            } else {
                OnboardingView()
                    .environment(purchaseManager)
            }
        }
        .modelContainer(for: [Quote.self, QuoteTier.self, QuoteItem.self, Client.self, ProductLibrary.self, BusinessProfile.self])
    }
}
