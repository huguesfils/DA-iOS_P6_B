import SwiftUI

@MainActor @Observable
final class CandidateViewModel: ObservableObject {
    private let networkService = NetworkService()
    private let tokenManager = TokenManager.shared
    @ObservationIgnored
    @Binding private var isLogged: Bool

    var searchText = ""
    var showOnlyFavorites = false
    var candidates: [Candidate] = []
    var alertMessage: String = ""
    var showAlert = false

    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            (searchText.isEmpty || "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)) &&
            (!showOnlyFavorites || candidate.isFavorite)
        }
    }

    init(isLogged: Binding<Bool>) {
        self._isLogged = isLogged
    }

    func fetchCandidates() async {
        do {
            let fetchedCandidates: [Candidate] = try await networkService.sendRequest(endpoint: .getCandidates)
            candidates = fetchedCandidates
            print("Candidats récupérés: \(candidates)")
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            showAlert = true
            print("Erreur: \(error.errorMessage)")
        } catch {
            alertMessage = "Une erreur inconnue est survenue."
            showAlert = true
            print("Erreur inconnue: \(error.localizedDescription)")
        }
    }

    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged = false
    }
}
