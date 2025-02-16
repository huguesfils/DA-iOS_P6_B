import SwiftUI

@MainActor
final class CandidateViewModel: ObservableObject {
    private var isLogged: Binding<Bool>
    
    init(isLogged: Binding<Bool>) {
        self.isLogged = isLogged
    }
    
    func logout() async {
        await NetworkService.shared.clearAuthToken()
        isLogged.wrappedValue = false
    }
}
