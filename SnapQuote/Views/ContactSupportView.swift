import SwiftUI

struct ContactSupportView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var topic = "General"
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Billing", "Other"]

    var body: some View {
        Form {
            Section("Contact Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { Text($0) }
                }
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 100)
            }

            Section {
                Button(action: submitFeedback) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                        }
                        Text("Submit")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    message = ""
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        isSubmitting = true
        let payload: [String: Any] = [
            "name": name,
            "email": email,
            "topic": topic,
            "message": message,
            "app": "SnapQuote"
        ]

        guard let url = URL(string: "https://formsubmit.co/iocompile67692@gmail.com") else {
            isSubmitting = false
            alertMessage = "Failed to submit. Please try again."
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                } else {
                    alertMessage = "Thank you! Your message has been sent successfully."
                }
                showAlert = true
            }
        }.resume()
    }
}
