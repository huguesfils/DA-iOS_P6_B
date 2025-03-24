import SwiftUI

struct ContentView: View {
    @Binding var isLogged: Bool
    
    var body: some View {
        if isLogged {
            CandidateListView(viewModel: CandidateListViewModel(isLogged: $isLogged))
                .navigationTransition(.automatic)
        } else {
            LoginView(isLogged: $isLogged)
                .navigationTransition(.automatic)
        }
    }
}

#Preview {
    ContentView(isLogged: .constant(false))
}
