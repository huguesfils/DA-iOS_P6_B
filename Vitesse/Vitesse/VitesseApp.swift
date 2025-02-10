import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isLogged  {
                CandidateView(viewModel: viewModel.candidateViewModel)
            } else {
                LoginView(viewModel: viewModel.loginViewModel)
            }
        }
    }
}
