import Foundation
import Testing
@testable import Vitesse

@MainActor
struct CreateCandidateViewModelTests {
    
    @Test
    func testCreateCandidate_success() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "dummy-token", isAdmin: false)
        
        let candidate = Candidate(id: "1", firstName: "Jane", lastName: "Doe", email: "jane@mail.com", phone: "0600000000", note: "Top dev", linkedinURL: "linkedin.com/in/jane", isFavorite: false)
        
        let mockService = MockNetworkService()
        await mockService.setResponse(candidate)
        
        
        let viewModel = CreateCandidateViewModel(networkService: mockService)
        
        
        
        viewModel.firstName = "Jane"
        viewModel.lastName = "Doe"
        viewModel.email = "jane@mail.com"
        viewModel.phone = "0600000000"
        viewModel.note = "Top dev"
        viewModel.linkedinURL = "linkedin.com/in/jane"
        
        await viewModel.createCandidate()
        
        #expect(viewModel.showAlert == false)
        
    }
    
    @Test
    func testCreateCandidate_failure_withVitesseError() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "dummy-token", isAdmin: false)
        
        let mockService = MockNetworkService()
        await mockService.setShouldThrowError(true, error: VitesseError.candidateCreationFailed)
        
        let viewModel = CreateCandidateViewModel(networkService: mockService)
        
        viewModel.firstName = "Jane"
        viewModel.lastName = "Doe"
        viewModel.email = "jane@mail.com"
        viewModel.phone = ""
        viewModel.note = ""
        viewModel.linkedinURL = ""
        
        await viewModel.createCandidate()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.candidateCreationFailed.errorMessage)
        
    }
    
    @Test
    func testCreateCandidate_failure_withUnknownError() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "dummy-token", isAdmin: false)
        
        let mockService = MockNetworkService()
        await mockService.setShouldThrowError(true, error: URLError(.badServerResponse))
        
        let viewModel = CreateCandidateViewModel(networkService: mockService)

        viewModel.firstName = "Jane"
        viewModel.lastName = "Doe"
        viewModel.email = "jane@mail.com"
        viewModel.phone = ""
        viewModel.note = ""
        viewModel.linkedinURL = ""
        
        await viewModel.createCandidate()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.candidateCreationFailed.errorMessage)
        
    }
}
