import SwiftUI

struct ContentView: View {
    @Binding var isLogged: Bool
    
    var body: some View {
        if isLogged {
            CandidateView(viewModel: CandidateViewModel(isLogged: $isLogged))
            //TODO: voir animation de transition login/logout
        } else {
            LoginView(isLogged: $isLogged)
        }
    }
}

#Preview {
    ContentView(isLogged: .constant(false))
}
