import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    
    private let networkService = NetworkService.shared
    
    func register() async {
        isLoading = true
        
        do {
            try await networkService.sendVoidRequest(endpoint: .register(email: email, password: password, firstName: firstName, lastName: lastName))
            isLoading = false
        } catch let error as VitesseError {
//            alertMessage = error.errorMessage
            isLoading = false
//            showAlert = true
        } catch {
//            alertMessage = "Une erreur inconnue est survenue."
            isLoading = false
//            showAlert = true
        }
    }
}
