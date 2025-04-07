import SwiftUI

@MainActor @Observable
final class CandidateDetailViewModel {
    private let networkService = NetworkService()
    
    var alertMessage: String = ""
    var showAlert = false
    var candidate: Candidate
    var isEditing: Bool = false
    var editedFirstName: String
    var editedLastName: String
    var editedEmail: String
    var editedPhone: String
    var editedLinkedinURL: String
    var editedNote: String
    let isAdmin: Bool
    
    init(candidate: Candidate, isAdmin: Bool) {
        self.candidate = candidate
        self.isAdmin = isAdmin

        self.editedFirstName = candidate.firstName
        self.editedLastName = candidate.lastName
        self.editedEmail = candidate.email
        self.editedPhone = candidate.phone ?? ""
        self.editedLinkedinURL = candidate.linkedinURL ?? ""
        self.editedNote = candidate.note ?? ""
    }
    
    func startEditing() {
        editedFirstName = candidate.firstName
        editedLastName = candidate.lastName
        editedEmail = candidate.email
        editedPhone = candidate.phone ?? ""
        editedLinkedinURL = candidate.linkedinURL ?? ""
        editedNote = candidate.note ?? ""
        isEditing = true
    }
    
    func cancelEditing() {
        isEditing = false
    }
    
    func doneEditing() {
        Task {
            do {
                let updatedCandidate: Candidate = try await networkService.sendRequest(endpoint: .updateCandidate(
                    candidateId: candidate.id,
                    email: editedEmail,
                    note: editedNote.isEmpty ? nil : editedNote,
                    linkedinURL: editedLinkedinURL.isEmpty ? nil : editedLinkedinURL,
                    firstName: editedFirstName,
                    lastName: editedLastName,
                    phone: editedPhone.isEmpty ? nil : editedPhone
                ))
                
                self.candidate = updatedCandidate
                self.isEditing = false
            } catch let error as VitesseError {
                alertMessage = error.errorMessage
                showAlert = true
            } catch {
                alertMessage = "Une erreur inconnue est survenue."
                showAlert = true
            }
        }
    }
    
    func toggleFavorite() {
        guard isAdmin else { return }

        Task {
            do {
                let updatedCandidate: Candidate = try await networkService.sendRequest(endpoint: .toggleFavorite(candidateId: candidate.id))
                self.candidate = updatedCandidate
            } catch let error as VitesseError {
                alertMessage = error.errorMessage
                showAlert = true
            } catch {
                alertMessage = "Une erreur inconnue est survenue."
                showAlert = true
            }
        }
    }
}
