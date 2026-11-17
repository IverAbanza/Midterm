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
    let customerEmail: String
    let customerId: UUID?
    let address: String
    let paymentMethod: String

    init(
        id: String,
        createdAt: Date,
        status: String,
        items: [OrderItem],
        subtotal: Double,
        shipping: Double,
        total: Double,
        customerName: String,
        customerEmail: String = "",
        customerId: UUID? = nil,
        address: String,
        paymentMethod: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.status = status
        self.items = items
        self.subtotal = subtotal
        self.shipping = shipping
        self.total = total
        self.customerName = customerName
        self.customerEmail = customerEmail
        self.customerId = customerId
        self.address = address
        self.paymentMethod = paymentMethod
    }
}
