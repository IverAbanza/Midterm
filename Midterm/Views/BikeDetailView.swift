import SwiftUI

struct BikeDetailView: View {
    let bike: Bike
    let bikeController: BikeController?
    let cartController: CartController?
    let userController: UserController?

    @State private var selectedColor: String
    @State private var selectedSize: String

    init(
        bike: Bike,
        bikeController: BikeController? = nil,
        cartController: CartController? = nil,
        userController: UserController? = nil
    ) {
        self.bike = bike
        self.bikeController = bikeController
        self.cartController = cartController
        self.userController = userController
        _selectedColor = State(initialValue: bike.colors.first ?? "Blue")
        _selectedSize = State(initialValue: bike.sizes.first ?? "M")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(bike.accent.opacity(0.16))
                        .frame(height: 290)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10, weight: .bold))
                        Text(String(format: "%.1f", bike.rating))
                            .font(.system(size: 12, weight: .bold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.22))
                    .clipShape(Capsule())
                    .padding(16)

                    Image(systemName: "bicycle")
                        .font(.system(size: 110, weight: .bold))
                        .foregroundStyle(bike.accent)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(bike.name)
                        .font(.system(size: 32, weight: .heavy))

                    Text(bike.type)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(AppTheme.mutedText)

                    HStack {
                        Text("₱\(Int(bike.price))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppTheme.navy)
                        Spacer()
                        Text(bike.isAvailable ? "In stock" : "Sold out")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(bike.isAvailable ? .green : .red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background((bike.isAvailable ? Color.green : Color.red).opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Available colors")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 12) {
                        ForEach(bike.colors, id: \.self) { colorName in
                            Button {
                                selectedColor = colorName
                            } label: {
                                Text(colorName)
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 62)
                                    .background(selectedColor == colorName ? AppTheme.navy : AppTheme.card)
                                    .foregroundStyle(selectedColor == colorName ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose size")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 10) {
                        ForEach(bike.sizes, id: \.self) { size in
                            Button {
                                selectedSize = size
                            } label: {
                                Text(size)
                                    .font(.system(size: 12, weight: .semibold))
                                    .frame(width: 58, height: 38)
                                    .background(selectedSize == size ? AppTheme.navy : AppTheme.card)
                                    .foregroundStyle(selectedSize == size ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Specifications")
                        .font(.system(size: 18, weight: .bold))

                    ForEach(Array(bike.specs.keys.sorted()), id: \.self) { key in
                        HStack {
                            Text(key)
                                .foregroundStyle(AppTheme.mutedText)
                            Spacer()
                            Text(bike.specs[key] ?? "")
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                        .padding(12)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("About this bike")
                        .font(.system(size: 18, weight: .bold))

                    Text(bike.description)
                        .foregroundStyle(AppTheme.mutedText)
                        .lineSpacing(4)
                }

                Button {
                    cartController?.add(bike: bike)
                } label: {
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("Add to Cart")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.navy, AppTheme.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: AppTheme.blue.opacity(0.2), radius: 10, x: 0, y: 8)
                }
            }
            .padding(20)
        }
        .navigationTitle("Bike Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BikeDetailView(bike: sampleBikes[0])
    }
}
