import Foundation
import Testing
@testable import Vitesse

@MainActor
struct LoginViewModelTests {
    
    @Test
    func testLogin_success() async throws {
        var isLogged = false
        let mockService = MockNetworkService()
        await mockService.setResponse(AuthResponse(token: "mockToken123", isAdmin: false))
        
        let viewModel = LoginViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        
        viewModel.email = "user@example.com"
        viewModel.password = "password123"
        
        await viewModel.login()
        
        #expect(isLogged == true)
        #expect(viewModel.showAlert == false)
    }
    
    @Test
    func testLoginWithInvalidEmail() async throws {
        var isLogged = false
        let mockService = MockNetworkService()
        
        let viewModel = LoginViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        
        viewModel.email = "invalid-email"
        viewModel.password = "pass"
        
        await viewModel.login()
        
        #expect(viewModel.showAlert == true)
        #expect(viewModel.alertMessage == VitesseError.invalidEmail.errorMessage)
    }
}
