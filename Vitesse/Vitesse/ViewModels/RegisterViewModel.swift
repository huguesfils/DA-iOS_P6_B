import SwiftUI

@MainActor @Observable
final class RegisterViewModel {
     var firstName = ""
     var lastName = ""
     var email = ""
     var password = ""
     var confirmPassword = ""
     var isLoading = false
     var showAlert = false
     var alertMessage: String = ""
    
    @ObservationIgnored
    @Binding var isLogged: Bool
    
    private let networkService = NetworkService()
    private let tokenManager = TokenManager.shared
    
    init(isLogged: Binding<Bool>) {
        self._isLogged = isLogged
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
            alertMessage = "Une erreur inconnue est survenue."
            isLoading = false
            showAlert = true
        }
    }
    
    private func loginAfterRegister() async {
        do {
            let response: AuthResponse = try await networkService.sendRequest(
                endpoint: .auth(email: email, password: password)
            )
            
            await tokenManager.setAuthToken(response.token)
            isLogged = true
            
        } catch {
            alertMessage = "Une erreur inconnue est survenue."
            showAlert = true
        }
    }

}
