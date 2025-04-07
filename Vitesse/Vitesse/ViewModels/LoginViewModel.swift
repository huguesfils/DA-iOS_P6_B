import SwiftUI

@MainActor @Observable
final class LoginViewModel {
    private let networkService = NetworkService()
    private let tokenManager = TokenManager.shared
    
    @ObservationIgnored
    @Binding var isLogged: Bool
    
    var email = ""
    var password = ""
    var showAlert = false
    var isLoading = false
    var alertMessage: String = ""
    
    init(isLogged: Binding<Bool>) {
        self._isLogged = isLogged
    }
    
    func login() async {
        if let error = ValidateCredentialsHelper.validateCredentials(email: email, password: password) {
            alertMessage = error.errorMessage
            showAlert = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: AuthResponse = try await networkService.sendRequest(
                endpoint: APIEndpoint.auth(email: email, password: password)
            )
            await tokenManager.setAuth(token: response.token, isAdmin: response.isAdmin)
            self.isLogged = true
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            showAlert = true
        } catch {
            alertMessage = "Une erreur inconnue est survenue."
            showAlert = true
        }
    }
}
