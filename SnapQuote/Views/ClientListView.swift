import SwiftUI
import SwiftData

struct ClientListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Client.name) private var clients: [Client]
    @State private var searchText = ""
    @State private var showingAddClient = false

    var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.company.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClients, id: \.id) { client in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(client.name).font(.body.bold())
                            if !client.company.isEmpty {
                                Text("· \(client.company)").font(.caption).foregroundColor(.secondary)
                            }
                        }
                        if !client.email.isEmpty {
                            Text(client.email).font(.caption).foregroundColor(.secondary)
                        }
                        if !client.phone.isEmpty {
                            Text(client.phone).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteClients)
            }
            .searchable(text: $searchText, prompt: "Search clients...")
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddClient = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddClient) {
                AddClientView()
            }
        }
    }

    private func deleteClients(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredClients[index])
            }
        }
    }
}

struct AddClientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var company = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Info") {
                    TextField("Name", text: $name)
                    TextField("Company", text: $company)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
                Section("Address") {
                    TextField("Address", text: $address)
                }
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let client = Client(
                            name: name,
                            email: email,
                            phone: phone,
                            address: address,
                            company: company,
                            notes: notes
                        )
                        modelContext.insert(client)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
