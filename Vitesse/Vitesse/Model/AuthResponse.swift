import Foundation

struct AuthResponse: Decodable, Encodable {
    let token: String
    var isAdmin: Bool
}
