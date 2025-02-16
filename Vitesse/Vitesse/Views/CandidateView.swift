import SwiftUI

struct CandidateView: View {
    @StateObject var viewModel: CandidateViewModel
    
    var body: some View {
        VStack {
            Text("Bienvenue dans CandidateView 👋")
                .font(.title)
                .padding()
            
            Button("Se déconnecter") {
                Task {
                    await viewModel.logout()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Candidats")
    }
}

#Preview {
    CandidateView(viewModel: CandidateViewModel(isLogged: .constant(true)))
}
