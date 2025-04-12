import Foundation

enum APIEndpoint {
    case auth(email: String, password: String)
    case register(email: String, password: String, firstName: String, lastName: String)
    case getCandidates
    case createCandidate(email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String)
    case deleteCandidate(candidateId: String)
    case updateCandidate(candidateId: String, email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String?)
    case toggleFavorite(candidateId: String)
    
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
        case .updateCandidate(let id, _, _, _, _, _, _):
            return "/candidate/\(id)"
        case .toggleFavorite(let id):
            return "/candidate/\(id)/favorite"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth, .register, .createCandidate, .toggleFavorite:
            return .post
        case .getCandidates:
            return .get
        case .deleteCandidate:
            return .delete
        case .updateCandidate:
            return .put
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
        case .updateCandidate(_, let email, let note, let linkedinURL, let firstName, let lastName, let phone):
            return [
                "email": email,
                "note": note,
                "linkedinURL": linkedinURL,
                "firstName": firstName,
                "lastName": lastName,
                "phone": phone
            ]
        case .toggleFavorite:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .auth, .register:
            return false
        case .getCandidates, .createCandidate, .deleteCandidate, .updateCandidate, .toggleFavorite:
            return true
        }
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
}
