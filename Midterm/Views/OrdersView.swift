import SwiftUI

struct OrdersView: View {
    let orders: [Order]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("My Orders")
                    .font(.system(size: 32, weight: .heavy))

                if orders.isEmpty {
                    EmptyStateView(title: "No orders yet", message: "Your recent orders will appear here.", systemImage: "shippingbox")
                } else {
                    ForEach(orders, id: \ .id) { order in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(order.id)
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Text(order.status)
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundStyle(.green)
                                    .clipShape(Capsule())
                            }

                            Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .foregroundStyle(.secondary)

                            ForEach(order.items, id: \ .id) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Text("x\(item.quantity)")
                                }
                                .font(.system(size: 13, weight: .medium))
                            }

                            Divider()

                            HStack {
                                Text("Total")
                                Spacer()
                                Text("$\(Int(order.total))")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 5)
                    }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    OrdersView(orders: [])
}
