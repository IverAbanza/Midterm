import Foundation
import Combine

final class CartController: ObservableObject {
    @Published var items: [CartItem] = []

    private let key = "bikeStore.cart.items"

    init() {
        load()
    }

    func add(bike: Bike) {
        if let index = items.firstIndex(where: { $0.bikeId == bike.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(bikeId: bike.id, quantity: 1))
        }
        save()
    }

    func remove(bikeId: UUID) {
        items.removeAll { $0.bikeId == bikeId }
        save()
    }

    func updateQuantity(bikeId: UUID, delta: Int) {
        guard let index = items.firstIndex(where: { $0.bikeId == bikeId }) else { return }
        let next = items[index].quantity + delta
        if next <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = next
        }
        save()
    }

    func subtotal(for bikes: [Bike]) -> Double {
        items.reduce(0) { partial, item in
            guard let bike = bikes.first(where: { $0.id == item.bikeId }) else { return partial }
            return partial + (bike.price * Double(item.quantity))
        }
    }

    func total(for bikes: [Bike]) -> Double {
        subtotal(for: bikes) + shippingFee(for: bikes)
    }

    func shippingFee(for bikes: [Bike]) -> Double {
        subtotal(for: bikes) > 0 ? 0 : 0
    }

    func clear() {
        items.removeAll()
        save()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CartItem].self, from: data) else {
            items = []
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
