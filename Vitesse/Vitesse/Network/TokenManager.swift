import Foundation

actor TokenManager: TokenManagerInterface {
    static let shared = TokenManager()
    
    private var authToken: String?
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    func clearAuthToken() {
        self.authToken = nil
    }
}

protocol TokenManagerInterface {
    func setAuthToken(_ token: String) async
    func clearAuthToken() async
}
