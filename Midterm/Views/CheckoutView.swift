import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartController: CartController
    @ObservedObject var bikeController: BikeController
    @ObservedObject var orderController: OrderController
    @ObservedObject var userController: UserController

    let onOrderPlaced: (Order) -> Void

    @State private var shippingAddress = "123 Rizal St, Cebu City"
    @State private var contactName = ""
    @State private var phone = ""
    @State private var paymentMethod = "Cash on Delivery"
    @State private var errorMessage = ""

    var subtotal: Double {
        cartController.subtotal(for: bikeController.bikes)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Checkout")
                    .font(.system(size: 32, weight: .heavy))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Delivery information")
                        .font(.system(size: 18, weight: .bold))

                    TextField("Contact name", text: $contactName)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    TextField("Phone number", text: $phone)
                        .keyboardType(.phonePad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    TextField("Shipping address", text: $shippingAddress)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment method")
                        .font(.system(size: 18, weight: .bold))

                    Picker("Payment method", selection: $paymentMethod) {
                        Text("Cash on Delivery").tag("Cash on Delivery")
                        Text("GCash").tag("GCash")
                        Text("Credit/Debit Card").tag("Credit/Debit Card")
                    }
                    .pickerStyle(.segmented)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Order summary")
                        .font(.system(size: 18, weight: .bold))

                    HStack { Text("Subtotal"); Spacer(); Text("$\(Int(subtotal))") }
                    HStack { Text("Shipping"); Spacer(); Text("Free") }
                    HStack { Text("Total"); Spacer(); Text("$\(Int(subtotal))").fontWeight(.bold) }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }

                PrimaryButton(title: "Place Order", icon: "checkmark.circle") {
                    guard !contactName.isEmpty, !phone.isEmpty, !shippingAddress.isEmpty else {
                        errorMessage = "Please complete all delivery details."
                        return
                    }
                    let currentUser = userController.currentUser ?? User(id: UUID(), fullName: "Guest", email: "guest@example.com", phone: phone, password: "")
                    let order = orderController.createOrder(from: cartController.items, bikes: bikeController.bikes, user: currentUser, address: shippingAddress, paymentMethod: paymentMethod)
                    cartController.clear()
                    onOrderPlaced(order)
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    CheckoutView(
        cartController: CartController(),
        bikeController: BikeController(),
        orderController: OrderController(),
        userController: UserController(),
        onOrderPlaced: { _ in }
    )
}
