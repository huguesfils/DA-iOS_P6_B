import Foundation
@testable import Vitesse

actor MockNetworkService: NetworkServiceInterface {
    private var typedResponses: [String: Any] = [:]
    private var shouldThrowError: Bool = false
    private var errorToThrow: Error = VitesseError.unauthorized
    
    // MARK: - Config
    func setResponse<T: Decodable & Sendable>(_ response: T, for type: T.Type = T.self) {
        let key = String(describing: type)
        typedResponses[key] = response
    }

    func setShouldThrowError(_ value: Bool, error: Error = VitesseError.unauthorized) {
        self.shouldThrowError = value
        self.errorToThrow = error
    }

    func clearResponses() {
        typedResponses.removeAll()
    }
    
    // MARK: - NetworkServiceInterface
    func sendRequest<T: Decodable & Sendable>(endpoint: APIEndpoint) async throws -> T {
        if shouldThrowError {
            throw errorToThrow
        }

        let key = String(describing: T.self)
        guard let value = typedResponses[key] as? T else {
            throw VitesseError.decodingError
        }
        
        return value
    }

    func sendVoidRequest(endpoint: APIEndpoint) async throws {
        if shouldThrowError {
            throw errorToThrow
        }
    }
}
