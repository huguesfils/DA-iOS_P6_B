import SwiftUI

struct CreateCandidateView: View {
    @State private var viewModel = CreateCandidateViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal information")) {
                    TextField("First Name *", text: $viewModel.firstName)
                        .textInputAutocapitalization(.never)
                    TextField("Last Name *", text: $viewModel.lastName)
                        .textInputAutocapitalization(.never)
                }
                Section(header: Text("Contact")) {
                    TextField("Email *", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $viewModel.phone)
                }
                Section(header: Text("Additional Information")) {
                    TextField("Note", text: $viewModel.note)
                        .textInputAutocapitalization(.never)
                    TextField("LinkedIn URL", text: $viewModel.linkedinURL)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    Button("Create") {
                        Task {
                            await viewModel.createCandidate()
                            if !viewModel.showAlert {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.firstName.isEmpty || viewModel.lastName.isEmpty || viewModel.email.isEmpty)
                }
            }
            .navigationTitle("Create a Candidate")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

#Preview {
    CreateCandidateView()
}
