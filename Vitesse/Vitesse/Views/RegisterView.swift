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
            
            AuthTextField(placeholder: "First name", text: $viewModel.firstName)
            AuthTextField(placeholder: "Last name", text: $viewModel.lastName)
            AuthTextField(placeholder: "Email", text: $viewModel.email)
            AuthTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
            AuthTextField(placeholder: "Confirm password", text: $viewModel.confirmPassword, isSecure: true)
            
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
