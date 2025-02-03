import SwiftUI

@MainActor
final class CandidateViewModel: ObservableObject {
    @AppStorage("authToken") private var authToken: String?
    @Published var isLoggedIn: Bool = false

    init() {
        isLoggedIn = authToken != nil
    }

    func logout() {
        authToken = nil
        isLoggedIn = false
    }
}
