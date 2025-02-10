import SwiftUI

final class CandidateViewModel: ObservableObject {
    let onLogout: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLogout = callback
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLogged")
        UserDefaults.standard.synchronize()
        onLogout()
    }
}
