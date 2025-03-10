import SwiftUI

struct Candidate: Identifiable, Equatable{
    let id = UUID()
    let firstName: String
    let lastName: String
    var isFavorite: Bool
}
