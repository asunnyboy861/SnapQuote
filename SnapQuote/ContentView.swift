import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            QuoteListView()
                .tabItem {
                    Label("Estimates", systemImage: "doc.text")
                }
                .tag(0)

            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "person.2")
                }
                .tag(1)

            ProductLibraryView()
                .tabItem {
                    Label("Products", systemImage: "archivebox")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Quote.self, QuoteTier.self, QuoteItem.self, Client.self, ProductLibrary.self, BusinessProfile.self], inMemory: true)
}
