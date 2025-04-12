import Foundation

struct AuthResponse: Decodable {
    let token: String
    let isAdmin: Bool
}
