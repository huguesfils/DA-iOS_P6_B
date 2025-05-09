import SwiftUI

// MARK: Protocol
protocol NetworkServiceInterface: Sendable {
    func sendRequest<T: Decodable & Sendable>(endpoint: APIEndpoint) async throws -> T
    func sendVoidRequest(endpoint: APIEndpoint) async throws
}

// MARK: Network service
actor NetworkService: NetworkServiceInterface {
    private let baseURL = "http://127.0.0.1:8080"
    private let session: URLSession
    private let tokenManager = TokenManager.shared
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendRequest<T: Decodable & Sendable>(
        endpoint: APIEndpoint
    ) async throws -> T {
        let (data, httpStatusCode): (Data, Int) = try await perform(endpoint: endpoint)
        
        switch httpStatusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw VitesseError.decodingError
            }
        default:
            let error = handleError(httpStatusCode: httpStatusCode, data: data)
            throw error
        }
    }
    
    func sendVoidRequest(endpoint: APIEndpoint) async throws {
        
        let (data, httpStatusCode) = try await perform(endpoint: endpoint)
        
        switch httpStatusCode {
        case 200...299:
            return
        default:
            let error = handleError(httpStatusCode: httpStatusCode, data: data)
            throw error
        }
    }
    
    private func perform(endpoint: APIEndpoint) async throws -> (data: Data, response: Int) {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw VitesseError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = await self.tokenManager.authToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw VitesseError.unknownError(statusCode: -1)
        }
        
        return (data, httpResponse.statusCode)
    }
    
    private func handleError(httpStatusCode: Int, data: Data) -> Error {
        switch httpStatusCode {
        case 400:
            if let error = try? JSONDecoder().decode([String: String].self, from: data),
               let message = error["error"] {
                return VitesseError.customError(message: message)
            } else {
                return VitesseError.unauthorized
            }
        case 401:
            return VitesseError.unauthorized
        case 404:
            return VitesseError.notFound
        case 500...599:
            return VitesseError.serverError
        default:
            return VitesseError.unknownError(statusCode: httpStatusCode)
        }
    }
}
