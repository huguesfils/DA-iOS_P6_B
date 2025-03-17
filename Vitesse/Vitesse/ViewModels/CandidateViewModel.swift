import SwiftUI

@MainActor
final class CandidateViewModel: ObservableObject {
    private let tokenManager = TokenManager.shared
    private var isLogged: Binding<Bool>
    
    @Published var candidates: [Candidate] = [
        Candidate(firstName: "Jean", lastName: "Dupont", isFavorite: false),
        Candidate(firstName: "Marie", lastName: "Curie", isFavorite: true),
        Candidate(firstName: "Albert", lastName: "Einstein", isFavorite: false)
    ]
    
    @Published var searchText = ""
    @Published var showOnlyFavorites = false
    
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            (searchText.isEmpty || "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)) &&
            (!showOnlyFavorites || candidate.isFavorite)
        }
    }
    
    init(isLogged: Binding<Bool>) {
        self.isLogged = isLogged
    }
    
    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged.wrappedValue = false
    }
}
