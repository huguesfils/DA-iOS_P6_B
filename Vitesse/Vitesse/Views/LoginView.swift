import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                AuthTextField(placeholder: "Email", text: $email)
                AuthTextField(placeholder: "Password", text: $password, isSecure: true)

                Button(action: {
                   
                }) {
                    Text("Se connecter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                Spacer()

                Button(action: {
                    showRegister = true
                }) {
                    Text("Pas encore inscrit ? S'enregistrer")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.bottom, 10)

                NavigationLink(
                    destination: RegisterView(),
                    isActive: $showRegister,
                    label: {
                        EmptyView()
                    }
                )
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
