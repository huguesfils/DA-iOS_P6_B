import Foundation

enum APIEndpoint {
    case auth(email: String, password: String)
    
    var path: String {
        switch self {
        case .auth:
            return "/user/auth"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .auth(let email, let password):
            return ["email": email, "password": password]
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
