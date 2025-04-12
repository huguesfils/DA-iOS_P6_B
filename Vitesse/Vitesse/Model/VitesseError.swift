import Foundation

enum VitesseError: Error {
    case badURL
    case unauthorized
    case notFound
    case serverError
    case decodingError
    case unknownError(statusCode: Int)
    case customError(message: String)
    
    case invalidEmail
    case emptyPassword
    case invalidRecipient
    case invalidAmount
    case passwordMismatch
    case enterValue
    
    case candidateCreationFailed
    case candidateDeletionFailed
    
    var errorMessage: String {
        switch self {
        case .badURL:
            "Invalid URL."
        case .unauthorized:
            "Unauthorized access. Please check your credentials."
        case .notFound:
            "Resource not found."
        case .serverError:
            "Internal server error."
        case .decodingError:
            "Error decoding the data."
        case .unknownError(let statusCode):
            "Unknown error. Status code: \(statusCode)"
        case .customError(let message):
            message
        case .invalidEmail:
            "Invalid email address. Please enter a valid email."
        case .emptyPassword:
            "Password field is empty. Please enter a password."
        case .invalidRecipient:
            "Invalid recipient. Please enter a valid email or French phone number."
        case .invalidAmount:
            "Invalid amount. Please enter a positive number."
        case .passwordMismatch:
            "Passwords do not match."
        case .enterValue:
            "Please fill in all fields."
        case .candidateCreationFailed:
            "Failed to create candidate."
        case .candidateDeletionFailed:
            "Failed to delete candidate."
        }
    }
}
