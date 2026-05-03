import SwiftUI
import SwiftData

struct ProductLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProductLibrary.name) private var products: [ProductLibrary]
    @State private var searchText = ""
    @State private var showingAddProduct = false

    var filteredProducts: [ProductLibrary] {
        if searchText.isEmpty { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredProducts, id: \.id) { product in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.name).font(.body.bold())
                            if !product.category.isEmpty {
                                Text(product.category).font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        Text(product.defaultUnitPrice.currencyString)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                        Text("/\(product.defaultUnit)")
                            .font(.caption).foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteProducts)
            }
            .searchable(text: $searchText, prompt: "Search products...")
            .navigationTitle("Product Library")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddProduct = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProduct) {
                AddProductView()
            }
        }
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredProducts[index])
            }
        }
    }
}

struct AddProductView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var productDescription = ""
    @State private var category = ""
    @State private var unit = "ea"
    @State private var unitPrice = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Product Details") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $productDescription)
                    TextField("Category", text: $category)
                }
                Section("Pricing") {
                    HStack {
                        TextField("Price", text: $unitPrice)
                            .keyboardType(.decimalPad)
                        Picker("Unit", selection: $unit) {
                            ForEach(["ea", "hr", "sq ft", "ln ft", "lot", "day", "week", "month"], id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let product = ProductLibrary(
                            name: name,
                            productDescription: productDescription,
                            category: category,
                            defaultUnit: unit,
                            defaultUnitPrice: Double(unitPrice) ?? 0
                        )
                        modelContext.insert(product)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
