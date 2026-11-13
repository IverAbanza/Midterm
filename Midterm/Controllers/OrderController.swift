import Foundation

final class OrderController: ObservableObject {
    @Published var orders: [Order] = []

    private let key = "bikeStore.orders"

    init() {
        load()
    }

    func createOrder(from cart: [CartItem], bikes: [Bike], user: User, address: String, paymentMethod: String) -> Order {
        let items = cart.compactMap { cartItem -> OrderItem? in
            guard let bike = bikes.first(where: { $0.id == cartItem.bikeId }) else { return nil }
            return OrderItem(
                id: UUID(),
                bikeId: bike.id,
                name: bike.name,
                quantity: cartItem.quantity,
                unitPrice: bike.price
            )
        }

        let subtotal = items.reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
        let shipping = subtotal > 0 ? 0.0 : 0.0
        let total = subtotal + shipping
        let order = Order(
            id: "BK\(Int(Date().timeIntervalSince1970))",
            createdAt: Date(),
            status: "Processing",
            items: items,
            subtotal: subtotal,
            shipping: shipping,
            total: total,
            customerName: user.fullName,
            address: address,
            paymentMethod: paymentMethod
        )
        orders.insert(order, at: 0)
        save()
        return order
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Order].self, from: data) else {
            orders = []
            return
        }
        orders = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(orders) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
