import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var alertMessage: String = ""
    
    @Binding var isLogged: Bool
    
    private let networkService = NetworkService.shared
    private let tokenManager = TokenManager.shared
    
    init(isLogged: Binding<Bool>) {
           self._isLogged = isLogged
       }
    
    func login() async {
        if let error = validateCredentials() {
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func validateCredentials() -> VitesseError? {
        guard isValidEmail(email) else {
            return .invalidEmail
        }
        guard !password.isEmpty else {
            return .emptyPassword
        }
        return nil
    }
}
