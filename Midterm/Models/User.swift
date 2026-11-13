import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: UUID
    var fullName: String
    var email: String
    var phone: String
    var password: String
}
