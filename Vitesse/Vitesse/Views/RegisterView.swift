import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            AuthTextField(placeholder: "First name", text: $firstName)
            AuthTextField(placeholder: "Last name", text: $lastName)
            AuthTextField(placeholder: "Email", text: $email)
            AuthTextField(placeholder: "Password", text: $password, isSecure: true)
            AuthTextField(placeholder: "Confirm password", text: $password, isSecure: true)
            
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
