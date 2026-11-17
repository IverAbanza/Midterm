import SwiftUI

struct BikeCardView: View {
    let bike: Bike

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                BikeArtwork(bike: bike, height: 170)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10, weight: .bold))
                    Text(String(format: "%.1f", bike.rating))
                        .font(.system(size: 11, weight: .semibold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.22))
                .clipShape(Capsule())
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(bike.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(bike.type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
                    .lineLimit(1)

                HStack(alignment: .center, spacing: 8) {
                    Text("₱\(String(format: "%.0f", bike.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppTheme.navy)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 8)
    }
}

#Preview {
    BikeCardView(bike: sampleBikes[0])
        .padding()
}
