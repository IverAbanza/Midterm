import SwiftUI

struct CartView: View {
    @ObservedObject var cartController: CartController
    @ObservedObject var bikeController: BikeController

    var body: some View {
        NavigationStack {
            if cartController.items.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(.secondary)

                    Text("Your cart is empty")
                        .font(.system(size: 22, weight: .bold))

                    Text("Add a bike to begin your next ride.")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .navigationTitle("Cart")
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(cartController.items, id: \.id) { item in
                            if let bike = bikeController.bikes.first(where: { $0.id == item.bikeId }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(bike.accent.opacity(0.16))
                                            .frame(width: 76, height: 76)
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundStyle(bike.accent)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bike.name)
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("\(item.quantity) item(s)")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("₱\(Int(bike.price * Double(item.quantity)))")
                                            .font(.system(size: 15, weight: .bold))
                                        Button(role: .destructive) {
                                            cartController.remove(bikeId: bike.id)
                                        } label: {
                                            Text("Remove")
                                                .font(.system(size: 11, weight: .semibold))
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Summary")
                                .font(.system(size: 20, weight: .bold))

                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("₱\(Int(cartController.subtotal(for: bikeController.bikes)))")
                                    .fontWeight(.semibold)
                            }

                            HStack {
                                Text("Delivery")
                                Spacer()
                                Text("Free")
                                    .fontWeight(.semibold)
                            }

                            Divider()

                            HStack {
                                Text("Total")
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                                Text("₱\(Int(cartController.total(for: bikeController.bikes)))")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                        Button {
                            print("Checkout tapped")
                        } label: {
                            Text("Proceed to Checkout")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding()
                }
                .navigationTitle("Cart")
            }
        }
    }
}

#Preview {
    CartView(cartController: CartController(), bikeController: BikeController())
}
