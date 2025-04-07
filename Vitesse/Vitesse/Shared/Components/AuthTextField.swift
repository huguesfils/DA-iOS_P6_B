import SwiftUI

struct AuthTextField: View {
    @Binding var text: String
    
    let placeholder: String
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    AuthTextField(text: .constant(""), placeholder: "Email")
}
