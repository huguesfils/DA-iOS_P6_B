import Foundation

enum ValidateCredentialsHelper {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func validateCredentials(email: String, firstName: String, lastName: String, password: String, confirmPassword: String) -> VitesseError? {
        guard isValidEmail(email) else {
            return .invalidEmail
        }
        guard !firstName.isEmpty, !lastName.isEmpty else {
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
    
    static func validateCredentials(email: String, password: String) -> VitesseError? {
        guard isValidEmail(email) else {
            return .invalidEmail
        }
        guard !password.isEmpty else {
            return .emptyPassword
        }
        return nil
    }
}
