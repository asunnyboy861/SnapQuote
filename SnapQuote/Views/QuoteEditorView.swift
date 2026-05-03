import SwiftUI
import SwiftData

struct QuoteEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var quote: Quote
    @State private var selectedTierIndex: Int = 0
    @State private var showingSignature = false
    @State private var showingPDFPreview = false
    @State private var showingPaywall = false

    init(quote: Quote?) {
        let newQuote = quote ?? Quote(number: QuoteNumberGenerator.generate())
        _quote = State(initialValue: newQuote)
    }

    private var isEditing: Bool {
        quote.number.isEmpty == false && quote.createdAt != Date()
    }

    var body: some View {
        Form {
            projectSection
            clientSection
            tiersSection
            taxDiscountSection
            notesSection
            signatureSection
            actionsSection
        }
        .navigationTitle(quote.projectName.isEmpty ? "New Estimate" : quote.projectName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveQuote() }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .sheet(isPresented: $showingSignature) {
            SignatureView(quote: $quote)
        }
        .sheet(isPresented: $showingPDFPreview) {
            if let pdfData = PDFGenerator.generate(quote: quote) {
                PDFPreviewView(pdfData: pdfData, quote: quote)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }

    private var projectSection: some View {
        Section("Project") {
            TextField("Project Name", text: $quote.projectName)
            TextField("Estimate Number", text: $quote.number)
            DatePicker("Valid Until", selection: $quote.validUntil, displayedComponents: .date)
            Picker("Status", selection: $quote.status) {
                ForEach(QuoteStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
        }
    }

    private var clientSection: some View {
        Section("Client") {
            TextField("Name", text: $quote.clientName)
            TextField("Email", text: $quote.clientEmail)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            TextField("Phone", text: $quote.clientPhone)
                .keyboardType(.phonePad)
            TextField("Address", text: $quote.clientAddress)
        }
    }

    private var tiersSection: some View {
        Section {
            if quote.tiers.isEmpty {
                Button(action: addDefaultTiers) {
                    Label("Add Good/Better/Best Tiers", systemImage: "square.3.layers.3d")
                }
            } else {
                Picker("Tier", selection: $selectedTierIndex) {
                    ForEach(0..<quote.tiers.count, id: \.self) { index in
                        Text(quote.tiers[index].level.rawValue).tag(index)
                    }
                }
                .pickerStyle(.segmented)

                if selectedTierIndex < quote.tiers.count {
                    let tier = quote.tiers[selectedTierIndex]
                    TierEditorContent(tier: tier, quote: quote)
                }
            }
        } header: {
            HStack {
                Text("Tiers")
                Spacer()
                if !quote.tiers.isEmpty {
                    Button(action: addDefaultTiers) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private var taxDiscountSection: some View {
        Section("Tax & Discount") {
            HStack {
                Text("Tax Rate")
                Spacer()
                TextField("0", value: $quote.taxRate, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("%")
            }
            HStack {
                Text("Discount")
                Spacer()
                TextField("0", value: $quote.discountRate, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("%")
            }
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            TextField("Additional notes...", text: $quote.notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    private var signatureSection: some View {
        Section("Signature") {
            if quote.signatureData != nil {
                HStack {
                    if let sigData = quote.signatureData, let uiImage = UIImage(data: sigData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 60)
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button("Clear") {
                        quote.signatureData = nil
                        quote.signedAt = nil
                        quote.signedByName = nil
                    }
                    .foregroundColor(.red)
                }
            } else {
                Button(action: { showingSignature = true }) {
                    Label("Add Signature", systemImage: "pencil.tip")
                }
            }
        }
    }

    private var actionsSection: some View {
        Section {
            Button(action: {
                if purchaseManager.isProUnlocked {
                    showingPDFPreview = true
                } else {
                    showingPaywall = true
                }
            }) {
                Label("Preview PDF", systemImage: "doc.richtext")
            }

            if quote.signatureData != nil {
                Button(action: { quote.status = .sent }) {
                    Label("Mark as Sent", systemImage: "paperplane")
                }
            }
        }
    }

    private func addDefaultTiers() {
        let good = QuoteTier(level: .good, name: "Basic", tierDescription: "Essential work with standard materials", colorHex: "#34C759", sortOrder: 0)
        let better = QuoteTier(level: .better, name: "Recommended", tierDescription: "Quality work with premium materials", colorHex: "#FF9500", sortOrder: 1)
        let best = QuoteTier(level: .best, name: "Premium", tierDescription: "Top-tier work with best materials and warranty", colorHex: "#AF52DE", sortOrder: 2)

        good.quote = quote
        better.quote = quote
        best.quote = quote

        quote.tiers = [good, better, best]
        selectedTierIndex = 0
    }

    private func saveQuote() {
        if quote.tiers.isEmpty {
            let good = QuoteTier(level: .good, name: "Basic", tierDescription: "", colorHex: "#34C759", sortOrder: 0)
            good.quote = quote
            quote.tiers = [good]
        }

        if !isEditing {
            modelContext.insert(quote)
        }
        dismiss()
    }
}

struct TierEditorContent: View {
    let tier: QuoteTier
    let quote: Quote

    @State private var newItemName = ""
    @State private var newItemPrice = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Tier name", text: .init(
                    get: { tier.name },
                    set: { tier.name = $0 }
                ))
                .font(.subheadline.bold())
            }

            TextField("Description", text: .init(
                get: { tier.tierDescription },
                set: { tier.tierDescription = $0 }
            ))
            .font(.caption)

            ForEach(tier.items.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { item in
                ItemRowView(item: item)
            }

            HStack {
                TextField("Item name", text: $newItemName)
                TextField("Price", text: $newItemPrice)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                Button("Add") {
                    addItem()
                }
                .disabled(newItemName.isEmpty)
            }
            .font(.subheadline)

            PriceCalculatorView(
                subtotal: tier.subtotal,
                taxRate: quote.taxRate,
                discountRate: quote.discountRate,
                taxAmount: tier.taxAmount,
                discountAmount: tier.discountAmount,
                total: tier.totalAmount
            )
        }
    }

    private func addItem() {
        let price = Double(newItemPrice) ?? 0
        let item = QuoteItem(
            name: newItemName,
            unitPrice: price,
            sortOrder: tier.items.count
        )
        item.tier = tier
        tier.items.append(item)
        newItemName = ""
        newItemPrice = ""
    }
}
