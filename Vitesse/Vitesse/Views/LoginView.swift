import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel

    init(isLogged: Binding<Bool>) {
        self._viewModel = State(wrappedValue: LoginViewModel(isLogged: isLogged))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                AuthTextField(text: $viewModel.email, placeholder: "Email")
                AuthTextField(text: $viewModel.password, placeholder: "Password", isSecure: true)

                Button {
                    Task {
                        await viewModel.login()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Sign In")
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
                    destination: RegisterView(isLogged: viewModel.$isLogged),
                    label: {
                        Text("Not registered yet? Sign up")
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
            Alert(title: Text("Error"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    LoginView(isLogged: .constant(true))
}
