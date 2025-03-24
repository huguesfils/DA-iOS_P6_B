import Foundation

actor TokenManager {
    static let shared = TokenManager()

    var authToken: String?
    
    fileprivate init() {}
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    func clearAuthToken() {
        self.authToken = nil
    }
}
