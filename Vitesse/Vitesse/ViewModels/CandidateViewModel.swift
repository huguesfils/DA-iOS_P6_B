import SwiftUI

@MainActor @Observable
final class CandidateViewModel: ObservableObject {
    private let tokenManager = TokenManager.shared
    @ObservationIgnored
    @Binding private var isLogged: Bool
    
    var searchText = ""
    var showOnlyFavorites = false
    var candidates: [Candidate] = [
        Candidate(firstName: "Jean", lastName: "Dupont", isFavorite: false),
        Candidate(firstName: "Marie", lastName: "Curie", isFavorite: true),
        Candidate(firstName: "Albert", lastName: "Einstein", isFavorite: false)
    ]
    
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            (searchText.isEmpty || "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)) &&
            (!showOnlyFavorites || candidate.isFavorite)
        }
    }
    
    init(isLogged: Binding<Bool>) {
        self._isLogged = isLogged
    }
    
    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged = false
    }
}
