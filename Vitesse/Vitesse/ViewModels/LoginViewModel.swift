import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var alertMessage: String = ""
    @Binding var isLoggedIn:Bool
    
    private let networkService = NetworkService.shared
    
    init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
    }
    
    // MARK: - Login
    func login() async {
        if let error = validateCredentials() {
            alertMessage = error.errorMessage
            showAlert = true
            return
        }
        
        do {
            let response: AuthResponse = try await networkService.sendRequest(
                endpoint: APIEndpoint.auth(email: email, password: password)
            )
            await networkService.setAuthToken(response.token)
            isLoggedIn = true
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            showAlert = true
        } catch {
            alertMessage = "Une erreur inconnue est survenue."
            showAlert = true
            print(error)
        }
        isLoggedIn = false
    }
    
    // MARK: - Credentials validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
