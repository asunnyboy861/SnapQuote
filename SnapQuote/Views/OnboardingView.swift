import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                icon: "doc.text.magnifyingglass",
                title: "Create Estimates Fast",
                subtitle: "Generate professional estimates in 30 seconds right from your iPhone or iPad.",
                accentColor: .blue
            )
            .tag(0)

            OnboardingPage(
                icon: "square.3.layers.3d",
                title: "Good, Better, Best",
                subtitle: "The #1 sales strategy for contractors. Give clients options, close more deals.",
                accentColor: .tierBetter
            )
            .tag(1)

            OnboardingPage(
                icon: "wifi.slash",
                title: "Works Offline",
                subtitle: "No internet? No problem. Create estimates anywhere — basements, job sites, anywhere.",
                accentColor: .tierGood
            )
            .tag(2)

            OnboardingPage(
                icon: "pencil.tip",
                title: "Sign & Send",
                subtitle: "Capture signatures on-site and send branded PDFs instantly.",
                accentColor: .tierBest
            )
            .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .overlay(alignment: .bottom) {
            Button(action: {
                if currentPage < 3 {
                    withAnimation { currentPage += 1 }
                } else {
                    hasCompletedOnboarding = true
                }
            }) {
                Text(currentPage < 3 ? "Next" : "Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(accentColor)

            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}
