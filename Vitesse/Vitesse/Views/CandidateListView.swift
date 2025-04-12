import SwiftUI

struct CandidateListView: View {
    @State var viewModel: CandidateListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.filteredCandidates) { candidate in
                        NavigationLink(destination: CandidateDetailView(
                            viewModel: CandidateDetailViewModel(candidate: candidate, isAdmin: viewModel.isAdmin)
                        )) {
                            CandidateCardView(candidate: candidate)
                        }
                    }
                    .onDelete { offsets in
                        Task {
                            await viewModel.deleteCandidate(at: offsets)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "Rechercher")
                
                //TODO: Sheet
                NavigationLink(destination: CreateCandidateView()) {
                    Text("Créer un candidat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .padding()
            .navigationTitle("Candidats")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear {
                Task {
                    await viewModel.fetchCandidates()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        Task {
                            await viewModel.logout()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.showOnlyFavorites.toggle()
                    }) {
                        Image(systemName: viewModel.showOnlyFavorites ? "star.fill" : "star")
                            .foregroundColor(viewModel.showOnlyFavorites ? .yellow : .gray)
                    }
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    CandidateListView(viewModel: CandidateListViewModel(isLogged: .constant(true)))
}
