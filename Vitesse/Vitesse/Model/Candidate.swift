import SwiftUI

struct Candidate: Identifiable, Equatable, Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let note: String?
    let linkedinURL: String?
    let isFavorite: Bool
    
    //active record pattern isFavorite ?
}
