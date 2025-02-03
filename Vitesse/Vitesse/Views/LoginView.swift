import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                AuthTextField(placeholder: "Email", text: $email)
                AuthTextField(placeholder: "Password", text: $password, isSecure: true)

                Button(action: {
                   //TODO: auth
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
    }
}

#Preview {
    LoginView()
}
