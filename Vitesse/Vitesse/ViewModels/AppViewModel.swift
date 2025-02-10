import Foundation

@MainActor
class AppViewModel: ObservableObject {
    @Published var isLogged: Bool {
        didSet {
            UserDefaults.standard.set(isLogged, forKey: "isLogged")
        }
    }
    
    init() {
        self.isLogged = UserDefaults.standard.bool(forKey: "isLogged")
    }
    
    var loginViewModel: LoginViewModel {
        return LoginViewModel { [weak self] in
            self?.isLogged = true
        }
    }
    
    var candidateViewModel: CandidateViewModel {
        return CandidateViewModel { [weak self] in
            self?.isLogged = false
        }
    }
}
