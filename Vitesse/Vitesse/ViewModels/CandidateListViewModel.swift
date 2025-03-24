import SwiftUI

@MainActor @Observable
final class CandidateListViewModel: ObservableObject {
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
    
    func deleteCandidate(at offsets: IndexSet) async {
        for index in offsets {
            let candidateToDelete = filteredCandidates[index]
            do {
                try await networkService.sendVoidRequest(endpoint: .deleteCandidate(candidateId: candidateToDelete.id))
                if let idx = candidates.firstIndex(of: candidateToDelete) {
                    candidates.remove(at: idx)
                }
                print("Candidat supprimé: \(candidateToDelete)")
            } catch let error as VitesseError {
                alertMessage = error.errorMessage
                showAlert = true
                print("Erreur lors de la suppression: \(error.errorMessage)")
            } catch {
                alertMessage = VitesseError.candidateDeletionFailed.errorMessage
                showAlert = true
                print("Erreur inconnue lors de la suppression: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged = false
    }
}
