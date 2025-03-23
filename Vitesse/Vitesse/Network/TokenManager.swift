import Foundation

protocol TokenManagerInterface {
    func setAuthToken(_ token: String) async
    func clearAuthToken() async
    func getAuthToken() async -> String?
}

actor TokenManager: TokenManagerInterface {
    static let shared = TokenManager()

    private var authToken: String?
    
    fileprivate init() {}
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    func clearAuthToken() {
        self.authToken = nil
    }
    
    func getAuthToken() -> String? {
        return authToken
    }
}
