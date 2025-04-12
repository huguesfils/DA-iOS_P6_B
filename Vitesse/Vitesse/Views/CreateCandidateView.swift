import SwiftUI

struct CreateCandidateView: View {
    @State private var viewModel = CreateCandidateViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Prénom *", text: $viewModel.firstName)
                        .textInputAutocapitalization(.never)
                    TextField("Nom *", text: $viewModel.lastName)
                        .textInputAutocapitalization(.never)
                }
                Section(header: Text("Contact")) {
                    TextField("Email *", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                    TextField("Téléphone", text: $viewModel.phone)
                }
                Section(header: Text("Informations supplémentaires")) {
                    TextField("Note", text: $viewModel.note)
                        .textInputAutocapitalization(.never)
                    TextField("LinkedIn URL", text: $viewModel.linkedinURL)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    Button("Créer") {
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
            .navigationTitle("Créer un candidat")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

#Preview {
    CreateCandidateView()
}
