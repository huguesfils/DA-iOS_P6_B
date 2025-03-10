import SwiftUI

struct CandidateView: View {
    @ObservedObject var viewModel: CandidateViewModel
    
    @State private var candidates: [Candidate] = [
        Candidate(firstName: "Jean", lastName: "Dupont", isFavorite: false),
        Candidate(firstName: "Marie", lastName: "Curie", isFavorite: true),
        Candidate(firstName: "Albert", lastName: "Einstein", isFavorite: false)
    ]
    
    @State private var searchText = ""
    @State private var showOnlyFavorites = false
    
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            (searchText.isEmpty || "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)) &&
            (!showOnlyFavorites || candidate.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredCandidates) { candidate in
                        CandidateCardView(candidate: candidate)
                    }
                    .onDelete { indexSet in
                        candidates.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Search candidates")
                
                Button("Se déconnecter") {
                    Task {
                        await viewModel.logout()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Candidates")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showOnlyFavorites.toggle()
                    }) {
                        Image(systemName: showOnlyFavorites ? "star.fill" : "star")
                            .foregroundColor(showOnlyFavorites ? .yellow : .gray)
                    }
                    
                    EditButton()
                }
            }
        }
        
    }
}

struct CandidateCardView: View {
    let candidate: Candidate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(candidate.firstName) \(candidate.lastName)")
                    .font(.headline)
            }
            Spacer()
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundColor(candidate.isFavorite ? .yellow : .gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CandidateView(viewModel: CandidateViewModel(isLogged: .constant(true)))
}
