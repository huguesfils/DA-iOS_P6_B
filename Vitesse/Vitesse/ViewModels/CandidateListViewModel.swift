import SwiftUI

@MainActor @Observable
final class CandidateListViewModel {
    private let networkService : NetworkServiceInterface
    private let tokenManager = TokenManager.shared
    
    @ObservationIgnored
    @Binding private var isLogged: Bool
    
    var searchText = ""
    var showOnlyFavorites = false
    var candidates: [Candidate] = []
    var isAdmin: Bool = false
    var alertMessage: String = ""
    var showAlert = false
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            (searchText.isEmpty || "\(candidate.firstName) \(candidate.lastName)".localizedCaseInsensitiveContains(searchText)) &&
            (!showOnlyFavorites || candidate.isFavorite)
        }
    }
    
    init(isLogged: Binding<Bool>, networkService: NetworkServiceInterface = NetworkService()) {
        self._isLogged = isLogged
        self.networkService = networkService
    }
    
    func fetchCandidates() async {
        do {
            self.isAdmin = await tokenManager.isAdmin
            let fetchedCandidates: [Candidate] = try await networkService.sendRequest(endpoint: .getCandidates)
            candidates = fetchedCandidates
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            showAlert = true
        } catch {
            alertMessage = "An unknown error occurred."
            showAlert = true
        }
    }
    
    func deleteCandidate(at offsets: IndexSet) async {
        await withTaskGroup(of: (Candidate, Result<Void, Error>).self) { group in
            for index in offsets {
                guard filteredCandidates.indices.contains(index) else { continue }
                let candidateToDelete = filteredCandidates[index]
                group.addTask {
                    do {
                        try await self.networkService.sendVoidRequest(endpoint: .deleteCandidate(candidateId: candidateToDelete.id))
                        return (candidateToDelete, .success(()))
                    } catch {
                        return (candidateToDelete, .failure(error))
                    }
                }
            }
            
            for await (candidate, result) in group {
                switch result {
                case .success:
                    if let idx = candidates.firstIndex(of: candidate) {
                        candidates.remove(at: idx)
                    }
                case .failure(let error):
                    if let vitesseError = error as? VitesseError {
                        alertMessage = vitesseError.errorMessage
                    } else {
                        alertMessage = VitesseError.candidateDeletionFailed.errorMessage
                    }
                    showAlert = true
                }
            }
        }
    }
    
    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged = false
    }
}
