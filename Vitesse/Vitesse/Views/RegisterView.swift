import SwiftUI

struct RegisterView: View {
    @State private var viewModel: RegisterViewModel
    
    init(isLogged: Binding<Bool>) {
        self._viewModel = State(wrappedValue: RegisterViewModel(isLogged: isLogged))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            AuthTextField(text: $viewModel.firstName, placeholder: "First name")
            AuthTextField(text: $viewModel.lastName, placeholder: "Last name")
            AuthTextField(text: $viewModel.email, placeholder: "Email")
            AuthTextField(text: $viewModel.password, placeholder: "Password", isSecure: true)
            AuthTextField(text: $viewModel.confirmPassword, placeholder: "Confirm password", isSecure: true)
            
            Button(action: {
                Task {
                    await viewModel.register()
                }
            }) {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Erreur"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(isLogged: .constant(false))
    }
}
