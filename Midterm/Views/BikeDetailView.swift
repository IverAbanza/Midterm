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
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(bike.accent.opacity(0.16))
                        .frame(height: 260)

                    Image(systemName: "bicycle")
                        .font(.system(size: 110, weight: .bold))
                        .foregroundStyle(bike.accent)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(bike.name)
                        .font(.system(size: 32, weight: .heavy))

                    Text(bike.type)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.secondary)

                    Text("₱\(Int(bike.price))")
                        .font(.system(size: 24, weight: .bold))
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
                                    .background(selectedColor == colorName ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
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
                                    .background(selectedSize == size ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
                                    .foregroundStyle(selectedSize == size ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("About this bike")
                        .font(.system(size: 18, weight: .bold))

                    Text(bike.description)
                        .foregroundStyle(.secondary)
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
                    .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
