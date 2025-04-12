import Foundation

actor TokenManager {
    static let shared = TokenManager()

    var authToken: String?
    var isAdmin: Bool = false

    fileprivate init() {}

    func setAuth(token: String, isAdmin: Bool) {
        self.authToken = token
        self.isAdmin = isAdmin
    }

    func clearAuthToken() {
        self.authToken = nil
        self.isAdmin = false
    }
}
