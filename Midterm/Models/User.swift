import Foundation

struct User: Identifiable, Codable, Hashable {
    static let adminEmail = "admin@bikestore.com"
    static let adminRole = "admin"
    static let customerRole = "customer"

    let id: UUID
    var fullName: String
    var email: String
    var phone: String
    var address: String = ""
    var password: String
    var role: String = User.customerRole

    var isAdmin: Bool {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedRole = role.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return normalizedEmail == Self.adminEmail && normalizedRole == Self.adminRole
    }
}
