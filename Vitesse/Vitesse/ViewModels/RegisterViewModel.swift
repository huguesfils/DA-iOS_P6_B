import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var shouldNavigateToLogin = false
    
    private let networkService = NetworkService.shared
    
    func register() async {
        if let error = validateCredentials() {
            alertMessage = error.errorMessage
            showAlert = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await networkService.sendVoidRequest(endpoint: .register(email: email, password: password, firstName: firstName, lastName: lastName))
            isLoading = false
            shouldNavigateToLogin = true
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func validateCredentials() -> VitesseError? {
        guard isValidEmail(email) else {
            return .invalidEmail
        }
        guard !firstName.isEmpty || !lastName.isEmpty else {
            return .enterValue
        }
        guard !password.isEmpty else {
            return .emptyPassword
        }
        guard password == confirmPassword else {
            return .passwordMismatch
        }
        return nil
    }
    
    // TODO: enum helper avec static func + revoir defer
}
