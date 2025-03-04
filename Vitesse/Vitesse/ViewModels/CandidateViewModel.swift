import SwiftUI

@MainActor
final class CandidateViewModel: ObservableObject {
    private let tokenManager = TokenManager.shared
    
    private var isLogged: Binding<Bool>
    
    init(isLogged: Binding<Bool>) {
        self.isLogged = isLogged
    }
    
    func logout() async {
        await tokenManager.clearAuthToken()
        isLogged.wrappedValue = false
    }
}
