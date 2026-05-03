import SwiftUI
import SwiftData

struct QuoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Quote.createdAt, order: .reverse) private var quotes: [Quote]
    @State private var searchText = ""
    @State private var selectedStatus: QuoteStatus?
    @State private var showingNewQuote = false

    var filteredQuotes: [Quote] {
        quotes.filter { quote in
            let matchesSearch = searchText.isEmpty ||
                quote.clientName.localizedCaseInsensitiveContains(searchText) ||
                quote.projectName.localizedCaseInsensitiveContains(searchText) ||
                quote.number.localizedCaseInsensitiveContains(searchText)
            let matchesStatus = selectedStatus == nil || quote.status == selectedStatus
            return matchesSearch && matchesStatus
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if filteredQuotes.isEmpty {
                    ContentUnavailableView(
                        "No Estimates",
                        systemImage: "doc.text",
                        description: Text("Tap + to create your first estimate")
                    )
                } else {
                    ForEach(filteredQuotes, id: \.id) { quote in
                        NavigationLink(destination: QuoteEditorView(quote: quote)) {
                            QuoteRowView(quote: quote)
                        }
                    }
                    .onDelete(perform: deleteQuotes)
                }
            }
            .searchable(text: $searchText, prompt: "Search estimates...")
            .navigationTitle("SnapQuote")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingNewQuote = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Status", selection: $selectedStatus) {
                            Text("All").tag(nil as QuoteStatus?)
                            ForEach(QuoteStatus.allCases, id: \.self) { status in
                                Label(status.rawValue, systemImage: statusIcon(status)).tag(status as QuoteStatus?)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingNewQuote) {
                QuoteEditorView(quote: nil)
            }
        }
    }

    private func statusIcon(_ status: QuoteStatus) -> String {
        switch status {
        case .draft: return "doc"
        case .sent: return "paperplane"
        case .viewed: return "eye"
        case .accepted: return "checkmark.circle"
        case .declined: return "xmark.circle"
        case .expired: return "clock"
        }
    }

    private func deleteQuotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredQuotes[index])
            }
        }
    }
}

struct QuoteRowView: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(quote.projectName.isEmpty ? "Untitled Estimate" : quote.projectName)
                    .font(.headline)
                Spacer()
                StatusBadge(status: quote.status)
            }

            HStack {
                Text(quote.number)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("·")
                    .foregroundColor(.secondary)
                Text(quote.createdAt.shortDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !quote.clientName.isEmpty {
                Text(quote.clientName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                if !quote.tiers.isEmpty {
                    Label("\(quote.tiers.count) tier\(quote.tiers.count == 1 ? "" : "s")", systemImage: "square.3.layers.3d")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(quote.highestTotal.currencyString)
                    .font(.title3.bold())
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: QuoteStatus

    var color: Color {
        switch status {
        case .draft: return .gray
        case .sent: return .blue
        case .viewed: return .orange
        case .accepted: return .green
        case .declined: return .red
        case .expired: return .gray
        }
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(6)
    }
}
