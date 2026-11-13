import SwiftUI

struct BikeCardView: View {
    let bike: Bike

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "bicycle")
                .font(.system(size: 42, weight: .semibold))
                .frame(width: 82, height: 82)
                .foregroundStyle(.white)
                .background(bike.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 5) {
                Text(bike.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(bike.type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("₱\(Int(bike.price))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    BikeCardView(bike: sampleBikes[0])
}
