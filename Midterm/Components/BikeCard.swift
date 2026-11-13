import SwiftUI

struct BikeCard: View {
    let bike: Bike
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(bike.accent.opacity(0.14))
                        .frame(height: 160)

                    Image(systemName: "bicycle")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(bike.accent)
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity)

                    Button(action: {}) {
                        Image(systemName: "heart")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .offset(x: -8, y: 8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(bike.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(bike.type)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    HStack {
                        RatingView(rating: bike.rating, starSize: 12)
                        Text("(\(bike.reviewCount))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    Text("$\(Int(bike.price))")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(.primary)
                }
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
