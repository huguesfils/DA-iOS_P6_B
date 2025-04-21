import Foundation
import Testing
@testable import Vitesse

@MainActor
struct CandidateDetailViewModelTests {
    
    @Test
    func testStartAndCancelEditing() async throws {
        let candidate = Candidate(id: "1", firstName: "Alan", lastName: "Turing", email: "alan@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false)
        
        let viewModel = CandidateDetailViewModel(candidate: candidate, isAdmin: false)
        
        viewModel.startEditing()
        #expect(viewModel.isEditing == true)
        viewModel.cancelEditing()
        #expect(viewModel.isEditing == false)
    }
    
    @Test
    func testDoneEditing_success() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "token", isAdmin: true)
        
        let original = Candidate(id: "1", firstName: "Alan", lastName: "Turing", email: "alan@mail.com", phone: "000", note: "Old", linkedinURL: "linkedin", isFavorite: false)
        
        let updated = Candidate(id: "1", firstName: "Alan", lastName: "Mathison", email: "alan@math.com", phone: "123", note: "Updated", linkedinURL: "linkedin-updated", isFavorite: false)
        
        let mockService = MockNetworkService()
        await mockService.setResponse(updated)
        
        let viewModel = CandidateDetailViewModel(candidate: original, isAdmin: true, networkService: mockService)
        
        viewModel.startEditing()
        viewModel.editedLastName = "Mathison"
        viewModel.editedEmail = "alan@math.com"
        viewModel.editedPhone = "123"
        viewModel.editedNote = "Updated"
        viewModel.editedLinkedinURL = "linkedin-updated"
        
        await viewModel.doneEditing()
        
        #expect(viewModel.showAlert == false)
        #expect(viewModel.candidate.lastName == "Mathison")
    }
    
    @Test
    func testDoneEditing_failure() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "token", isAdmin: true)
        
        let candidate = Candidate(id: "1", firstName: "Alan", lastName: "Turing", email: "alan@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false)
        
        let mockService = MockNetworkService()
        await mockService.setShouldThrowError(true, error: VitesseError.serverError)
        
        let viewModel = CandidateDetailViewModel(candidate: candidate, isAdmin: true, networkService: mockService)
        
        viewModel.startEditing()
        viewModel.editedEmail = "test@fail.com"
        
        await viewModel.doneEditing()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.serverError.errorMessage)
    }
    
    @Test
    func testToggleFavorite_success() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "token", isAdmin: true)
        
        let original = Candidate(id: "1", firstName: "Ada", lastName: "Lovelace", email: "ada@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false)
        let updated = Candidate(id: "1", firstName: "Ada", lastName: "Lovelace", email: "ada@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: true)
        
        let mockService = MockNetworkService()
        await mockService.setResponse(updated)
        
        let viewModel = CandidateDetailViewModel(candidate: original, isAdmin: true, networkService: mockService)
        
        await viewModel.toggleFavorite()
        
        #expect(viewModel.candidate.isFavorite == true)
    }
    
    @Test
    func testToggleFavorite_failure() async throws {
        await TokenManager.shared.clearAuthToken()
        await TokenManager.shared.setAuth(token: "token", isAdmin: true)
        
        let candidate = Candidate(id: "1", firstName: "Ada", lastName: "Lovelace", email: "ada@mail.com", phone: nil, note: nil, linkedinURL: nil, isFavorite: false)
        
        let mockService = MockNetworkService()
        await mockService.setShouldThrowError(true, error: VitesseError.serverError)
        
        let viewModel = CandidateDetailViewModel(candidate: candidate, isAdmin: true, networkService: mockService)
        
        await viewModel.toggleFavorite()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.serverError.errorMessage)
    }
}
