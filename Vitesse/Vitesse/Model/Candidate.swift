import SwiftUI

struct Candidate: Identifiable, Equatable, Decodable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var note: String?
    var linkedinURL: String?
    var isFavorite: Bool
}
