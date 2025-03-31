import SwiftUI

struct CandidateCardView: View {
    let candidate: Candidate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(candidate.firstName) \(candidate.lastName)")
                    .font(.headline)
            }
            Spacer()
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundColor(candidate.isFavorite ? .yellow : .gray)
        }
        .padding(.vertical, 8)
    }
}
