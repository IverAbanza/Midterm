import SwiftUI

struct OrderConfirmationView: View {
    let order: Order
    let onContinueShopping: () -> Void
    let onViewOrders: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 110, height: 110)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 58))
                    .foregroundStyle(.green)
            }

            Text("Order placed successfully")
                .font(.system(size: 30, weight: .heavy))
                .multilineTextAlignment(.center)

            Text("Your order number is \(order.id)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                Text("Order summary")
                    .font(.system(size: 18, weight: .bold))
                HStack { Text("Total"); Spacer(); Text("$\(Int(order.total))") }
                HStack { Text("Payment"); Spacer(); Text(order.paymentMethod) }
                HStack { Text("Status"); Spacer(); Text(order.status) }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(spacing: 12) {
                PrimaryButton(title: "Continue Shopping", icon: "arrow.left") {
                    onContinueShopping()
                }

                Button(action: onViewOrders) {
                    Text("View My Orders")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(24)
    }
}

#Preview {
    OrderConfirmationView(
        order: Order(id: "BK123", createdAt: Date(), status: "Processing", items: [], subtotal: 1000, shipping: 0, total: 1000, customerName: "Rider", address: "Address", paymentMethod: "Cash on Delivery"),
        onContinueShopping: {},
        onViewOrders: {}
    )
}
