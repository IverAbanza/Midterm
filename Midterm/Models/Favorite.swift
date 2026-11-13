import Foundation

struct Favorite: Identifiable, Codable, Hashable {
    let id: UUID
    let bikeId: UUID
}
