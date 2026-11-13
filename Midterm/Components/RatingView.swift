import SwiftUI

struct RatingView: View {
    let rating: Double
    let starSize: CGFloat

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating.rounded()) ? "star.fill" : "star")
                    .foregroundStyle(index < Int(rating.rounded()) ? .yellow : .gray)
                    .font(.system(size: starSize))
            }
        }
    }
}
