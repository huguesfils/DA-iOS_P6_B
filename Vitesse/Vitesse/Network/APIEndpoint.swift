import Foundation

enum APIEndpoint {
    case auth(email: String, password: String)
    case register(email: String, password: String, firstName: String, lastName: String)
    case getCandidates
    case createCandidate(email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String)
    case deleteCandidate(candidateId: String)
    
    var path: String {
        switch self {
        case .auth:
            return "/user/auth"
        case .register:
            return "/user/register"
        case .getCandidates, .createCandidate:
            return "/candidate"
        case .deleteCandidate(let candidateId):
            return "/candidate/\(candidateId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth, .register, .createCandidate:
            return .post
        case .getCandidates:
            return .get
        case .deleteCandidate:
            return .delete
        }
    }
    
    var body: Encodable? {
        switch self {
        case .auth(let email, let password):
            return ["email": email, "password": password]
        case .register(let email, let password, let firstName, let lastName):
            return ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
        case .getCandidates, .deleteCandidate:
            return nil
        case .createCandidate(let email, let note, let linkedinURL, let firstName, let lastName, let phone):
            return [
                "email": email,
                "note": note,
                "linkedinURL": linkedinURL,
                "firstName": firstName,
                "lastName": lastName,
                "phone": phone
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .auth, .register:
            return false
        case .getCandidates, .createCandidate, .deleteCandidate:
            return true
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
