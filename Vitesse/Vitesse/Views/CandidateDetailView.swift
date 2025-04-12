import SwiftUI

struct CandidateDetailView: View {
    @State var viewModel: CandidateDetailViewModel

    @ViewBuilder
    var body: some View {
        NavigationStack {
            Form {
                nameSection
                detailsSection
                if viewModel.isAdmin {
                    favoriteSection
                }
            }
            .navigationTitle("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName)")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isEditing {
                        HStack {
                            Button("Cancel") {
                                viewModel.cancelEditing()
                            }
                            Spacer()
                            Button("Done") {
                                viewModel.doneEditing()
                            }
                        }
                    } else {
                        Button("Edit") {
                            viewModel.startEditing()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Name
    @ViewBuilder
    var nameSection: some View {
        Section(header: Text("Nom du candidat")) {
            if viewModel.isEditing {
                TextField("Prénom", text: $viewModel.editedFirstName)
                    .textInputAutocapitalization(.never)
                TextField("Nom", text: $viewModel.editedLastName)
                    .textInputAutocapitalization(.never)
            } else {
                Text("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName)")
                    .font(.headline)
            }
        }
    }

    // MARK: - Details
    @ViewBuilder
    var detailsSection: some View {
        Section(header: Text("Détails")) {
            if viewModel.isEditing {
                TextField("Téléphone", text: $viewModel.editedPhone)
                    .textInputAutocapitalization(.never)
                TextField("E-mail", text: $viewModel.editedEmail)
                    .textInputAutocapitalization(.never)
                TextField("LinkedIn", text: $viewModel.editedLinkedinURL)
                    .textInputAutocapitalization(.never)
                TextEditor(text: $viewModel.editedNote)
                    .frame(height: 100)
            } else {
                HStack {
                    Text("Téléphone")
                    Spacer()
                    Text(viewModel.candidate.phone ?? "-")
                }
                HStack {
                    Text("E-mail")
                    Spacer()
                    Text(viewModel.candidate.email)
                }
                HStack {
                    Text("LinkedIn")
                    Spacer()
                    Text(viewModel.candidate.linkedinURL ?? "-")
                }
                VStack(alignment: .leading) {
                    Text("Notes")
                    Text(viewModel.candidate.note ?? "-")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Favorite (Admin)
    @ViewBuilder
    var favoriteSection: some View {
        Section {
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                HStack {
                    Image(systemName: viewModel.candidate.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.candidate.isFavorite ? .yellow : .gray)
                    Text("Favoris")
                }
            }
        }
    }
}

#Preview {
    CandidateDetailView(viewModel: CandidateDetailViewModel(candidate: Candidate(id: "", firstName: "Hugues", lastName: "Fils", email: "huguesfils@mail.com", phone: "0600000000", note: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, neque eu efficitur aliquam, justo sem commodo risus, sed molestie quam est vitae erat. Praesent ut egestas nulla. Cras dictum, mauris ac tempor congue, dolor justo lobortis orci, eget tincidunt justo ex sit amet erat. Quisque luctus rhoncus est, ut finibus magna iaculis sed. Vestibulum condimentum nunc eu aliquam maximus. Aliquam at velit id lorem rutrum dignissim et quis nisl. ", linkedinURL: "linkedin@linkedin.com", isFavorite: true), isAdmin: true))
}
