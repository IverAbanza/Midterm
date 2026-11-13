import SwiftUI

struct CartView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var orderController: OrderController
    @ObservedObject var userController: UserController

    @State private var showCheckout = false
    @State private var completedOrder: Order?

    var body: some View {
        NavigationStack {
            Group {
                if cartController.items.isEmpty {
                    EmptyStateView(title: "Your cart is empty", message: "Add a bike to begin your ride.", systemImage: "cart")
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(cartController.items, id: \ .id) { item in
                                if let bike = bikeController.bikes.first(where: { $0.id == item.bikeId }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(bike.accent.opacity(0.12))
                                                .frame(width: 72, height: 72)
                                            Image(systemName: "bicycle")
                                                .font(.system(size: 28, weight: .bold))
                                                .foregroundStyle(bike.accent)
                                        }

                                        VStack(alignment: .leading) {
                                            Text(bike.name)
                                                .font(.system(size: 16, weight: .bold))
                                            Text(bike.type)
                                                .foregroundStyle(.secondary)
                                            Text("$\(Int(bike.price))")
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        HStack(spacing: 8) {
                                            Button(action: { cartController.updateQuantity(bikeId: bike.id, delta: -1) }) {
                                                Image(systemName: "minus")
                                                    .frame(width: 28, height: 28)
                                                    .background(Color(.systemGray6))
                                                    .clipShape(Circle())
                                            }

                                            Text("\(item.quantity)")
                                                .font(.system(size: 16, weight: .bold))

                                            Button(action: { cartController.updateQuantity(bikeId: bike.id, delta: 1) }) {
                                                Image(systemName: "plus")
                                                    .frame(width: 28, height: 28)
                                                    .background(Color(.systemGray6))
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Order summary")
                                    .font(.system(size: 20, weight: .bold))

                                HStack { Text("Subtotal"); Spacer(); Text("$\(Int(cartController.subtotal(for: bikeController.bikes)))") }
                                HStack { Text("Shipping"); Spacer(); Text("Free") }
                                Divider()
                                HStack { Text("Total"); Spacer(); Text("$\(Int(cartController.subtotal(for: bikeController.bikes)))").fontWeight(.bold) }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                            Button(action: { showCheckout = true }) {
                                Text("Proceed to Checkout")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationDestination(isPresented: $showCheckout) {
                CheckoutView(
                    cartController: cartController,
                    bikeController: bikeController,
                    orderController: orderController,
                    userController: userController,
                    onOrderPlaced: { order in
                        completedOrder = order
                        showCheckout = false
                    }
                )
            }
            .navigationDestination(item: $completedOrder) { order in
                OrderConfirmationView(
                    order: order,
                    onContinueShopping: {
                        completedOrder = nil
                    },
                    onViewOrders: {
                        completedOrder = nil
                    }
                )
            }
        }
    }
}

#Preview {
    CartView(
        bikeController: BikeController(),
        cartController: CartController(),
        orderController: OrderController(),
        userController: UserController()
    )
}
