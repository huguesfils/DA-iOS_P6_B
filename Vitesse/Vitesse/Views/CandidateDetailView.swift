import SwiftUI

struct CandidateDetailView: View {
    @State var viewModel: CandidateDetailViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nom du candidat")) {
                    if viewModel.isEditing {
                        TextField("Prénom", text: $viewModel.editedFirstName)
                        TextField("Nom", text: $viewModel.editedLastName)
                    } else {
                        Text("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName)")
                            .font(.headline)
                    }
                }
                
                Section(header: Text("Détails")) {
                    if viewModel.isEditing {
                        TextField("Téléphone", text: $viewModel.editedPhone)
                        TextField("E-mail", text: $viewModel.editedEmail)
                        TextField("LinkedIn", text: $viewModel.editedLinkedinURL)
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
                
                if viewModel.isAdmin {
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
            .navigationTitle("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName)")
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
}

#Preview {
    CandidateDetailView(viewModel: CandidateDetailViewModel(candidate: Candidate(id: "", firstName: "Hugues", lastName: "Fils", email: "huguesfils@mail.com", phone: "0600000000", note: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus varius, neque eu efficitur aliquam, justo sem commodo risus, sed molestie quam est vitae erat. Praesent ut egestas nulla. Cras dictum, mauris ac tempor congue, dolor justo lobortis orci, eget tincidunt justo ex sit amet erat. Quisque luctus rhoncus est, ut finibus magna iaculis sed. Vestibulum condimentum nunc eu aliquam maximus. Aliquam at velit id lorem rutrum dignissim et quis nisl. ", linkedinURL: "linkedin@linkedin.com", isFavorite: true), isAdmin: true))
}
