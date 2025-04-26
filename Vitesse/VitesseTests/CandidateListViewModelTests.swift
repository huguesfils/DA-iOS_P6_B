import Foundation
import Testing
@testable import Vitesse

@MainActor
struct CandidateListViewModelTests {
    
    @Test
    func testFetchCandidates_success() async throws {
        await TokenManager.shared.clearAuthToken()
        
        let candidates = [
            Candidate(id: "1", firstName: "Ada", lastName: "Lovelace", email: "ada@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false),
            Candidate(id: "2", firstName: "Alan", lastName: "Turing", email: "alan@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: true)
        ]
        
        let mockService = MockNetworkService()
        await mockService.setResponse(candidates)
        
        var isLogged = true
        let viewModel = CandidateListViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        await viewModel.fetchCandidates()
        
        #expect(viewModel.candidates.count == 2)
        #expect(viewModel.showAlert == false)
        
    }
    
    @Test
    func testFetchCandidates_failure() async throws {
        await TokenManager.shared.clearAuthToken()
        
        let mockService = MockNetworkService()
        await mockService.setShouldThrowError(true, error: VitesseError.serverError)
        
        var isLogged = true
        let viewModel = CandidateListViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        await viewModel.fetchCandidates()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.serverError.errorMessage)
    }
    
    @Test
    func testDeleteCandidate_success() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "token", isAdmin: true)
        
        let candidate = Candidate(id: "1", firstName: "Test", lastName: "User", email: "test@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false)
        
        let mockService = MockNetworkService()
        await mockService.setResponse([candidate])
        var isLogged = true
        
        let viewModel = CandidateListViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        await viewModel.fetchCandidates()
        
        viewModel.searchText = ""
        viewModel.showOnlyFavorites = false
        
        await viewModel.deleteCandidate(at: IndexSet(integer: 0))
        
        #expect(viewModel.candidates.isEmpty == true)
    }
    
    @Test
    func testLogout_setsIsLoggedFalse() async throws {
        await TokenManager.shared.clearAuthToken()
        
        let mockService = MockNetworkService()
        var isLogged = true
        
        let viewModel = CandidateListViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        await viewModel.logout()
        
        #expect(isLogged == false)
    }
}
