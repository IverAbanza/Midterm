import Foundation
import Combine

struct CartItem: Identifiable, Codable, Hashable {
    let id: UUID
    let bikeId: UUID
    var quantity: Int

    init(id: UUID = UUID(), bikeId: UUID, quantity: Int) {
        self.id = id
        self.bikeId = bikeId
        self.quantity = quantity
    }
}
