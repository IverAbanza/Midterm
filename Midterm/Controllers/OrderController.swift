import Foundation
import Combine

final class OrderController: ObservableObject {
    @Published var orders: [Order] = []

    private let key = "bikeStore.orders"

    init() {
        load()
    }

    var pendingOrders: [Order] {
        orders.filter { $0.status == "Pending" }
    }

    var completedOrders: [Order] {
        orders.filter { $0.status == "Completed" }
    }

    var totalRevenue: Double {
        orders.filter { $0.status != "Cancelled" }.reduce(0) { $0 + $1.total }
    }

    var totalSales: Int {
        orders.filter { $0.status != "Cancelled" }.count
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
            status: "Pending",
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

    func updateStatus(orderId: String, to status: String) -> Bool {
        guard let index = orders.firstIndex(where: { $0.id == orderId }) else { return false }
        let valid = ["Pending", "Processing", "Shipped", "Completed", "Cancelled"]
        guard valid.contains(status) else { return false }

        let current = orders[index].status
        if current == "Completed" && status != "Completed" { return false }
        if current == "Cancelled" && status != "Cancelled" { return false }
        if current == "Pending" && status == "Completed" { return false }

        orders[index] = Order(
            id: orders[index].id,
            createdAt: orders[index].createdAt,
            status: status,
            items: orders[index].items,
            subtotal: orders[index].subtotal,
            shipping: orders[index].shipping,
            total: orders[index].total,
            customerName: orders[index].customerName,
            address: orders[index].address,
            paymentMethod: orders[index].paymentMethod
        )
        save()
        return true
    }

    func cancelOrder(orderId: String) -> Bool {
        guard let index = orders.firstIndex(where: { $0.id == orderId }) else { return false }
        let status = orders[index].status
        if status == "Completed" || status == "Cancelled" { return false }

        orders[index] = Order(
            id: orders[index].id,
            createdAt: orders[index].createdAt,
            status: "Cancelled",
            items: orders[index].items,
            subtotal: orders[index].subtotal,
            shipping: orders[index].shipping,
            total: orders[index].total,
            customerName: orders[index].customerName,
            address: orders[index].address,
            paymentMethod: orders[index].paymentMethod
        )
        save()
        return true
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
