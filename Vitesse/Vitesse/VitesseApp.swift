import SwiftUI

@main
struct VitesseApp: App {
    @State var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                CandidateView(viewModel: CandidateViewModel())
            } else {
                LoginView(isLoggedIn: self.$isLoggedIn)
            }
        }
    }
}
