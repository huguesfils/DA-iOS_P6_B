import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(isLoggedIn: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: LoginViewModel(isLoggedIn: isLoggedIn))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                AuthTextField(placeholder: "Email", text: $viewModel.email)
                AuthTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Se connecter")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(20)
                
                Spacer()
                
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Pas encore inscrit ? S'enregistrer")
                            .foregroundColor(.blue)
                            .font(.footnote)
                    }
                )
                .padding(.bottom, 10)
                
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
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
    LoginView(isLoggedIn: .constant(false))
}
