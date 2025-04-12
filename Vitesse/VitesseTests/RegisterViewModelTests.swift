import Foundation
import Testing
@testable import Vitesse

struct RegisterViewModelTests {

    @Test
    func testRegister_success() async throws {
        var isLogged = false
        let mockService = MockNetworkService()
        await mockService.setResponse(AuthResponse(token: "token", isAdmin: false))

        let viewModel = await MainActor.run {
            RegisterViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        }

        await MainActor.run {
            viewModel.firstName = "Alan"
            viewModel.lastName = "Turing"
            viewModel.email = "alan@mail.com"
            viewModel.password = "1234"
            viewModel.confirmPassword = "1234"
        }

        await viewModel.register()

        await MainActor.run {
            #expect(isLogged == true)
            #expect(viewModel.showAlert == false)
        }
    }

    @Test
    func testRegister_invalidEmail() async throws {
        var isLogged = false
        let mockService = MockNetworkService()

        let viewModel = await MainActor.run {
            RegisterViewModel(isLogged: .init(get: { isLogged }, set: { isLogged = $0 }), networkService: mockService)
        }

        await MainActor.run {
            viewModel.firstName = "John"
            viewModel.lastName = "Doe"
            viewModel.email = "invalid-email"
            viewModel.password = "1234"
            viewModel.confirmPassword = "1234"
        }

        await viewModel.register()

        await MainActor.run {
            #expect(viewModel.showAlert == true)
            #expect(viewModel.alertMessage == VitesseError.invalidEmail.errorMessage)
        }
    }
}
