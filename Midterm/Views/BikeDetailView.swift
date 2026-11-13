import SwiftUI

struct BikeDetailView: View {
    let bike: Bike
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var selectedSize = "M"
    @State private var selectedColor = "Blue"
    @State private var quantity = 1
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(bike.accent.opacity(0.12))
                        .frame(height: 260)

                    Image(systemName: "bicycle")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundStyle(bike.accent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .secondary)
                            .padding(10)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(bike.name)
                        .font(.system(size: 30, weight: .heavy))

                    HStack {
                        RatingView(rating: bike.rating, starSize: 14)
                        Text("\(bike.rating, specifier: "%.1f")")
                            .font(.system(size: 14, weight: .semibold))
                        Text("(\(bike.reviewCount) reviews)")
                            .foregroundStyle(.secondary)
                    }

                    Text("$\(Int(bike.price))")
                        .font(.system(size: 28, weight: .heavy))
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.system(size: 18, weight: .bold))

                    Text(bike.description)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Available colors")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 12) {
                        ForEach(bike.colors, id: \ .self) { colorName in
                            Button(action: { selectedColor = colorName }) {
                                Text(colorName)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedColor == colorName ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
                                    .foregroundStyle(selectedColor == colorName ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Sizes")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 10) {
                        ForEach(bike.sizes, id: \ .self) { size in
                            Button(action: { selectedSize = size }) {
                                Text(size)
                                    .frame(width: 52, height: 36)
                                    .background(selectedSize == size ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
                                    .foregroundStyle(selectedSize == size ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Specifications")
                        .font(.system(size: 18, weight: .bold))

                    VStack(spacing: 10) {
                        ForEach(Array(bike.specs.keys.sorted()), id: \ .self) { key in
                            HStack {
                                Text(key)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(bike.specs[key] ?? "")
                                    .fontWeight(.semibold)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }

                HStack {
                    Text("Quantity")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: { if quantity > 1 { quantity -= 1 } }) {
                            Image(systemName: "minus")
                                .frame(width: 30, height: 30)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }

                        Text("\(quantity)")
                            .font(.system(size: 18, weight: .bold))
                        Button(action: { quantity += 1 }) {
                            Image(systemName: "plus")
                                .frame(width: 30, height: 30)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }

                PrimaryButton(title: "Add to Cart", icon: "cart.fill") {
                    cartController.add(bike: bike)
                }
            }
            .padding(20)
        }
        .navigationTitle("Bike Details")
    }
}

#Preview {
    NavigationStack {
        BikeDetailView(
            bike: sampleBikes[0],
            bikeController: BikeController(),
            cartController: CartController(),
            userController: UserController()
        )
    }
}
