import SwiftUI

@MainActor @Observable
final class CandidateDetailViewModel {
    var candidate: Candidate
    let isAdmin: Bool
    var isEditing: Bool = false
    
    var editedFirstName: String
    var editedLastName: String
    var editedEmail: String
    var editedPhone: String
    var editedLinkedinURL: String
    var editedNote: String
    
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
        candidate = Candidate(
            id: candidate.id,
            firstName: editedFirstName,
            lastName: editedLastName,
            email: editedEmail,
            phone: editedPhone.isEmpty ? nil : editedPhone,
            note: editedNote.isEmpty ? nil : editedNote,
            linkedinURL: editedLinkedinURL.isEmpty ? nil : editedLinkedinURL,
            isFavorite: candidate.isFavorite
        )
        isEditing = false
    }
    
    func toggleFavorite() {
        guard isAdmin else { return }
        candidate = Candidate(
            id: candidate.id,
            firstName: candidate.firstName,
            lastName: candidate.lastName,
            email: candidate.email,
            phone: candidate.phone,
            note: candidate.note,
            linkedinURL: candidate.linkedinURL,
            isFavorite: !candidate.isFavorite
        )
    }
}
