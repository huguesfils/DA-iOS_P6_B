import Foundation
import Testing
@testable import Vitesse

struct LoginViewModelTests {

    @Test
    func testLogin_success() async throws {
        var isLogged = false
        let mockService = MockNetworkService()
        await mockService.setResponse(AuthResponse(token: "mockToken123", isAdmin: false))

        let viewModel = await MainActor.run {
            LoginViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        }

        await MainActor.run {
            viewModel.email = "user@example.com"
            viewModel.password = "password123"
        }

        await viewModel.login()

        await MainActor.run {
            #expect(isLogged == true)
            #expect(viewModel.showAlert == false)
        }
    }

    @Test
    func testLoginWithInvalidEmail() async throws {
        var isLogged = false
        let mockService = MockNetworkService()

        let viewModel = await MainActor.run {
            LoginViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        }

        await MainActor.run {
            viewModel.email = "invalid-email"
            viewModel.password = "pass"
        }

        await viewModel.login()

        await MainActor.run {
            #expect(viewModel.showAlert == true)
            #expect(viewModel.alertMessage == VitesseError.invalidEmail.errorMessage)
        }
    }
}
