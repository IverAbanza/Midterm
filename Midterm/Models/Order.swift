import Foundation

struct OrderItem: Identifiable, Codable, Hashable {
    let id: UUID
    let bikeId: UUID
    let name: String
    let quantity: Int
    let unitPrice: Double
}

struct Order: Identifiable, Codable, Hashable {
    let id: String
    let createdAt: Date
    let status: String
    let items: [OrderItem]
    let subtotal: Double
    let shipping: Double
    let total: Double
    let customerName: String
    let address: String
    let paymentMethod: String
}
