import SwiftUI

struct BikeCardView: View {
    let bike: Bike

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(bike.accent.opacity(0.18))
                    .frame(height: 170)

                Image(systemName: "bicycle")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(bike.accent)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(bike.name)
                    .font(.system(size: 18, weight: .bold))

                Text(bike.type)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                HStack {
                    Text("₱\(Int(bike.price))")
                        .font(.system(size: 18, weight: .bold))
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
