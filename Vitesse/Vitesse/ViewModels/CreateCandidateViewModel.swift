import SwiftUI

@MainActor @Observable
final class CreateCandidateViewModel {
    private let networkService : NetworkServiceInterface
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
    var note: String = ""
    var linkedinURL: String = ""
    
    var isLoading: Bool = false
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    init(networkService: NetworkServiceInterface = NetworkService()) {
        self.networkService = networkService
    }
    
    func createCandidate() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _ : Candidate = try await networkService.sendRequest(
                endpoint: .createCandidate(
                    email: email,
                    note: note.isEmpty ? nil : note,
                    linkedinURL: linkedinURL.isEmpty ? nil : linkedinURL,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone
                )
            )
        } catch let error as VitesseError {
            alertMessage = error.errorMessage
            showAlert = true
        } catch {
            alertMessage = VitesseError.candidateCreationFailed.errorMessage
            showAlert = true
        }
    }
}
