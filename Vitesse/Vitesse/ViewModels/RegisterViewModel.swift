import SwiftUI

@MainActor @Observable
final class RegisterViewModel {
    private let networkService : NetworkServiceInterface
    private let tokenManager = TokenManager.shared
    
    @ObservationIgnored
    @Binding var isLogged: Bool
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var isLoading = false
    var showAlert = false
    var alertMessage: String = ""
    
    init(isLogged: Binding<Bool>, networkService: NetworkServiceInterface = NetworkService()) {
        self._isLogged = isLogged
        self.networkService = networkService
    }
    
    func register() async {
        if let error = ValidateCredentialsHelper.validateCredentials(email: email, firstName: firstName, lastName: lastName, password: password, confirmPassword: confirmPassword) {
            alertMessage = error.errorMessage
            showAlert = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await networkService.sendVoidRequest(endpoint: .register(email: email, password: password, firstName: firstName, lastName: lastName))
            await loginAfterRegister()
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            isLoading = false
            showAlert = true
        } catch {
            alertMessage = "An unknown error occurred."
            isLoading = false
            showAlert = true
        }
    }
    
    private func loginAfterRegister() async {
        do {
            let response: AuthResponse = try await networkService.sendRequest(
                endpoint: .auth(email: email, password: password)
            )
            
            await tokenManager.setAuth(token: response.token, isAdmin: false)
            isLogged = true
            
        } catch {
            alertMessage = "An unknown error occurred."
            showAlert = true
        }
    }
    
}
