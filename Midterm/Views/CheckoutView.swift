import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartController: CartController
    @ObservedObject var bikeController: BikeController
    @ObservedObject var userController: UserController
    @ObservedObject var orderController: OrderController

    let onOrderPlaced: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var deliveryAddress = ""
    @State private var paymentMethod = "Cash on Delivery"
    @State private var errorMessage = ""

    private let paymentOptions = [
        "Cash on Delivery",
        "Credit Card",
        "E-Wallet"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Checkout")
                            .font(.system(size: 30, weight: .heavy))

                        Text("Complete your order and we’ll get it moving.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Delivery address")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppTheme.navy)

                        TextEditor(text: $deliveryAddress)
                            .frame(minHeight: 100)
                            .padding(12)
                            .background(AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                            )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment method")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppTheme.navy)

                        Picker("Payment method", selection: $paymentMethod) {
                            ForEach(paymentOptions, id: \.self) { method in
                                Text(method).tag(method)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order summary")
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

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                    }

                    Button {
                        placeOrder()
                    } label: {
                        Text("Place Order")
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
                .padding(20)
            }
            .navigationTitle("Checkout")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            deliveryAddress = userController.currentUser?.address ?? ""
        }
    }

    private func placeOrder() {
        let trimmedAddress = deliveryAddress.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedAddress.isEmpty else {
            errorMessage = "Please enter a delivery address before placing the order."
            return
        }

        guard let user = userController.currentUser else {
            errorMessage = "Please log in to place an order."
            return
        }

        guard !cartController.items.isEmpty else {
            errorMessage = "Your cart is empty."
            return
        }

        if let stockIssue = orderController.validateCartStock(cartController.items, bikes: bikeController.bikes) {
            errorMessage = stockIssue
            return
        }

        _ = orderController.createOrder(
            from: cartController.items,
            bikes: bikeController.bikes,
            user: user,
            address: trimmedAddress,
            paymentMethod: paymentMethod
        )

        for item in cartController.items {
            bikeController.reduceStock(for: item.bikeId, quantity: item.quantity)
        }

        cartController.clear()
        errorMessage = ""
        onOrderPlaced()
    }
}

#Preview {
    CheckoutView(
        cartController: CartController(),
        bikeController: BikeController(),
        userController: UserController(),
        orderController: OrderController(),
        onOrderPlaced: {}
    )
}
