import SwiftUI

struct AppView: View {
    @State var isLoggedIn = false
    
    var body: some View {
        let _ = Self._printChanges()
        
        if isLoggedIn {
            CandidateView(viewModel: CandidateViewModel())
        } else {
            LoginView(isLoggedIn: self.$isLoggedIn)
        }
    }
}

#Preview {
    AppView()
}
