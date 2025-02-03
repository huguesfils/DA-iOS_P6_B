import SwiftUI

struct RegisterView: View {
   @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            AuthTextField(placeholder: "First name", text: $viewModel.firstName)
            AuthTextField(placeholder: "Last name", text: $viewModel.lastName)
            AuthTextField(placeholder: "Email", text: $viewModel.email)
            AuthTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
            AuthTextField(placeholder: "Confirm password", text: $viewModel.confirmPassword, isSecure: true)
            
            Button(action: {
                // TODO: register
            }) {
                Text("S'enregistrer")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
