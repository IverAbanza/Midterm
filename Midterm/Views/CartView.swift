import SwiftUI

struct CartView: View {
    @ObservedObject var cartController: CartController
    @ObservedObject var bikeController: BikeController

    var body: some View {
        NavigationStack {
            if cartController.items.isEmpty {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.blue.opacity(0.1))
                            .frame(width: 110, height: 110)
                        Image(systemName: "cart.fill")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(AppTheme.blue)
                    }

                    Text("Your cart is empty")
                        .font(.system(size: 22, weight: .bold))

                    Text("Add a bike to begin your next ride.")
                        .foregroundStyle(AppTheme.mutedText)
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
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(bike.accent.opacity(0.16))
                                            .frame(width: 78, height: 78)
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundStyle(bike.accent)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bike.name)
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("\(item.quantity) item(s)")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(AppTheme.mutedText)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("₱\(Int(bike.price * Double(item.quantity)))")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundStyle(AppTheme.navy)
                                        Button(role: .destructive) {
                                            cartController.remove(bikeId: bike.id)
                                        } label: {
                                            Text("Remove")
                                                .font(.system(size: 11, weight: .semibold))
                                        }
                                    }
                                }
                                .padding()
                                .background(AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Summary")
                                .font(.system(size: 20, weight: .bold))

                            HStack {
                                Text("Subtotal")
                                    .foregroundStyle(AppTheme.mutedText)
                                Spacer()
                                Text("₱\(Int(cartController.subtotal(for: bikeController.bikes)))")
                                    .fontWeight(.semibold)
                            }

                            HStack {
                                Text("Delivery")
                                    .foregroundStyle(AppTheme.mutedText)
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
                                    .foregroundStyle(AppTheme.navy)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                        Button {
                            print("Checkout tapped")
                        } label: {
                            Text("Proceed to Checkout")
                                .font(.system(size: 16, weight: .bold))
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
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .shadow(color: AppTheme.blue.opacity(0.18), radius: 10, x: 0, y: 8)
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
