import SwiftUI

struct CandidateView: View {
    @ObservedObject var viewModel: CandidateViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.filteredCandidates) { candidate in
                        CandidateCardView(candidate: candidate)
                    }
                    .onDelete { indexSet in
                        viewModel.candidates.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "Search")
      
                Spacer()
            }
            .padding()
            .navigationTitle("Candidates")
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
    CandidateView(viewModel: CandidateViewModel(isLogged: .constant(true)))
}
