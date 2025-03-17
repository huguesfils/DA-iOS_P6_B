import SwiftUI

@MainActor @Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var showAlert = false
    var isLoading = false
    var alertMessage: String = ""
    
    @ObservationIgnored
    @Binding var isLogged: Bool
    
    private let networkService = NetworkService()
    private let tokenManager = TokenManager.shared
    
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
            await tokenManager.setAuthToken(response.token)
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
