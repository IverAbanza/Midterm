import Foundation

#if canImport(Supabase)
import Supabase
#endif

struct SupabaseProfile: Codable {
    let id: UUID
    let fullName: String
    let email: String
    let phone: String?
    let role: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phone
        case role
    }

    func toUser(password: String = "") -> User {
        User(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone ?? "",
            password: password,
            role: role
        )
    }
}

struct SupabaseBike: Codable {
    let id: UUID
    let name: String
    let type: String
    let category: String
    let description: String
    let price: Double
    let rating: Double
    let reviewCount: Int
    let imageName: String?
    let accentColor: String?
    let sizes: [String]
    let colors: [String]
    let specs: [String: String]
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case category
        case description
        case price
        case rating
        case reviewCount = "review_count"
        case imageName = "image_name"
        case accentColor = "accent_color"
        case sizes
        case colors
        case specs
        case stock
    }

    func toBike() -> Bike {
        Bike(
            id: id,
            name: name,
            type: type,
            category: category,
            description: description,
            price: price,
            rating: rating,
            reviewCount: reviewCount,
            imageName: imageName ?? "",
            accentColor: accentColor ?? "#1264E8",
            sizes: sizes,
            colors: colors,
            specs: specs,
            stock: stock
        )
    }
}

struct SupabaseOrderItemPayload: Codable {
    let orderId: UUID
    let bikeId: UUID
    let name: String
    let quantity: Int
    let unitPrice: Double

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case bikeId = "bike_id"
        case name
        case quantity
        case unitPrice = "unit_price"
    }
}

#if canImport(Supabase)
final class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    init() {
        self.client = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.anonKey
        )
    }

    func signUp(fullName: String, email: String, password: String) async throws -> User {
        let authResponse = try await client.auth.signUp(email: email, password: password)

        let userId = authResponse.user.id
        let payload: [String: Any] = [
            "id": userId.uuidString,
            "full_name": fullName,
            "email": email,
            "role": SupabaseConfig.customerRole
        ]

        try await client.database
            .from("profiles")
            .insert(payload)
            .execute()

        return User(
            id: userId,
            fullName: fullName,
            email: email,
            phone: "",
            password: password,
            role: SupabaseConfig.customerRole
        )
    }

    func signIn(email: String, password: String) async throws -> User {
        let authResponse = try await client.auth.signIn(email: email, password: password)

        let profile: SupabaseProfile = try await client.database
            .from("profiles")
            .select()
            .eq("id", value: authResponse.user.id.uuidString)
            .single()
            .execute()
            .value

        return profile.toUser(password: password)
    }

    func fetchBikes() async throws -> [Bike] {
        let bikes: [SupabaseBike] = try await client.database
            .from("bikes")
            .select()
            .execute()
            .value

        return bikes.map { $0.toBike() }
    }

    func addBike(_ bike: Bike) async throws {
        let payload: [String: Any] = [
            "id": bike.id.uuidString,
            "name": bike.name,
            "type": bike.type,
            "category": bike.category,
            "description": bike.description,
            "price": bike.price,
            "rating": bike.rating,
            "review_count": bike.reviewCount,
            "image_name": bike.imageName,
            "accent_color": bike.accentColor,
            "sizes": bike.sizes,
            "colors": bike.colors,
            "specs": bike.specs,
            "stock": bike.stock
        ]

        try await client.database
            .from("bikes")
            .insert(payload)
            .execute()
    }

    func createOrder(userId: UUID, address: String, paymentMethod: String, cart: [CartItem], bikes: [Bike]) async throws -> Order {
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

        let subtotal = items.reduce(0.0) { $0 + ($1.unitPrice * Double($1.quantity)) }
        let total = subtotal

        let orderPayload: [String: Any] = [
            "user_id": userId.uuidString,
            "status": "Pending",
            "subtotal": subtotal,
            "shipping": 0.0,
            "total": total,
            "address": address,
            "payment_method": paymentMethod
        ]

        let createdOrder: [String: Any] = try await client.database
            .from("orders")
            .insert(orderPayload)
            .select()
            .single()
            .execute()
            .value

        let orderId = UUID(uuidString: createdOrder["id"] as? String ?? UUID().uuidString) ?? UUID()

        for item in items {
            let itemPayload: [String: Any] = [
                "order_id": orderId.uuidString,
                "bike_id": item.bikeId.uuidString,
                "name": item.name,
                "quantity": item.quantity,
                "unit_price": item.unitPrice
            ]

            try await client.database
                .from("order_items")
                .insert(itemPayload)
                .execute()
        }

        return Order(
            id: "BK\(Int(Date().timeIntervalSince1970))",
            createdAt: Date(),
            status: "Pending",
            items: items,
            subtotal: subtotal,
            shipping: 0.0,
            total: total,
            customerName: "",
            address: address,
            paymentMethod: paymentMethod
        )
    }

    func fetchOrders(for userId: UUID) async throws -> [Order] {
        let rows: [[String: Any]] = try await client.database
            .from("orders")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value

        return rows.compactMap { row in
            guard
                let id = row["id"] as? String,
                let status = row["status"] as? String,
                let subtotal = row["subtotal"] as? Double,
                let shipping = row["shipping"] as? Double,
                let total = row["total"] as? Double,
                let address = row["address"] as? String,
                let paymentMethod = row["payment_method"] as? String
            else {
                return nil
            }

            return Order(
                id: id,
                createdAt: Date(),
                status: status,
                items: [],
                subtotal: subtotal,
                shipping: shipping,
                total: total,
                customerName: "",
                address: address,
                paymentMethod: paymentMethod
            )
        }
    }
}
#else
final class SupabaseService {
    static let shared = SupabaseService()

    init() {}

    func signUp(fullName: String, email: String, password: String) async throws -> User {
        throw NSError(domain: "SupabaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Add the Supabase Swift package in Xcode to enable backend auth."])
    }

    func signIn(email: String, password: String) async throws -> User {
        throw NSError(domain: "SupabaseService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Add the Supabase Swift package in Xcode to enable backend auth."])
    }

    func fetchBikes() async throws -> [Bike] {
        return []
    }

    func addBike(_ bike: Bike) async throws {
        return
    }

    func createOrder(userId: UUID, address: String, paymentMethod: String, cart: [CartItem], bikes: [Bike]) async throws -> Order {
        throw NSError(domain: "SupabaseService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Add the Supabase Swift package in Xcode to enable backend order sync."])
    }

    func fetchOrders(for userId: UUID) async throws -> [Order] {
        return []
    }
}
#endif
