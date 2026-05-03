import SwiftUI

struct SignatureView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var quote: Quote
    @State private var signatureData: Data?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign Below")
                    .font(.headline)

                SignatureCanvas(signatureData: $signatureData)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                TextField("Signer Name", text: Binding(
                    get: { quote.signedByName ?? "" },
                    set: { quote.signedByName = $0 }
                ))
                .textFieldStyle(.roundedBorder)

                Spacer()
            }
            .padding()
            .navigationTitle("Signature")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        quote.signatureData = signatureData
                        quote.signedAt = signatureData != nil ? Date() : nil
                        dismiss()
                    }
                }
            }
        }
    }
}
