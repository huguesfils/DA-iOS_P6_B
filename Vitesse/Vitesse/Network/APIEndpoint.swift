import Foundation

enum APIEndpoint {
    case auth(email: String, password: String)
    case register(email: String, password: String, firstName: String, lastName: String)
    case getCandidates
    
    var path: String {
        switch self {
        case .auth:
            return "/user/auth"
        case .register:
            return "/user/register"
        case .getCandidates:
            return "/candidate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth:
            return .post
        case .register:
            return .post
        case .getCandidates:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .auth(let email, let password):
            return ["email": email, "password": password]
        case .register(let email, let password, let firstName, let lastName):
            return ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
        case .getCandidates:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .auth, .register:
            return false
        case .getCandidates:
            return true
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
