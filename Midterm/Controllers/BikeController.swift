import Foundation
import Combine

final class BikeController: ObservableObject {
    @Published var bikes: [Bike]
    private let storageKey = "bikeStore.catalog"

    init() {
        self.bikes = BikeController.loadSavedBikes() ?? sampleBikes
    }

    func filteredBikes(category: String = "All", searchText: String = "", sortBy: SortOption = .recommended) -> [Bike] {
        let normalized = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        var result = bikes.filter { bike in
            let matchesCategory = category == "All" || bike.category == category
            let matchesSearch = normalized.isEmpty ||
                bike.name.lowercased().contains(normalized) ||
                bike.type.lowercased().contains(normalized)
            return matchesCategory && matchesSearch
        }

        switch sortBy {
        case .recommended:
            result.sort { $0.rating > $1.rating }
        case .priceLowToHigh:
            result.sort { $0.price < $1.price }
        case .priceHighToLow:
            result.sort { $0.price > $1.price }
        case .rating:
            result.sort { $0.rating > $1.rating }
        }

        return result
    }

    func categories() -> [String] {
        Array(Set(bikes.map { $0.category })).sorted()
    }

    func addBike(_ bike: Bike) {
        bikes.append(bike)
        save()
    }

    func updateBike(_ bike: Bike) {
        if let index = bikes.firstIndex(where: { $0.id == bike.id }) {
            bikes[index] = bike
            save()
        }
    }

    func deleteBike(id: UUID) {
        bikes.removeAll { $0.id == id }
        save()
    }

    func reduceStock(for bikeId: UUID, quantity: Int) {
        guard let index = bikes.firstIndex(where: { $0.id == bikeId }) else { return }
        bikes[index] = Bike(
            id: bikes[index].id,
            name: bikes[index].name,
            type: bikes[index].type,
            category: bikes[index].category,
            description: bikes[index].description,
            price: bikes[index].price,
            rating: bikes[index].rating,
            reviewCount: bikes[index].reviewCount,
            imageName: bikes[index].imageName,
            accentColor: bikes[index].accentColor,
            sizes: bikes[index].sizes,
            colors: bikes[index].colors,
            specs: bikes[index].specs,
            stock: max(0, bikes[index].stock - quantity)
        )
        save()
    }

    func restoreStock(for bikeId: UUID, quantity: Int) {
        guard let index = bikes.firstIndex(where: { $0.id == bikeId }) else { return }
        bikes[index] = Bike(
            id: bikes[index].id,
            name: bikes[index].name,
            type: bikes[index].type,
            category: bikes[index].category,
            description: bikes[index].description,
            price: bikes[index].price,
            rating: bikes[index].rating,
            reviewCount: bikes[index].reviewCount,
            imageName: bikes[index].imageName,
            accentColor: bikes[index].accentColor,
            sizes: bikes[index].sizes,
            colors: bikes[index].colors,
            specs: bikes[index].specs,
            stock: bikes[index].stock + quantity
        )
        save()
    }

    func lowStockBikes() -> [Bike] {
        bikes.filter { $0.stock <= 5 }
    }

    func save() {
        guard let encoded = try? JSONEncoder().encode(bikes) else { return }
        UserDefaults.standard.set(encoded, forKey: storageKey)
    }

    private static func loadSavedBikes() -> [Bike]? {
        guard let data = UserDefaults.standard.data(forKey: "bikeStore.catalog"),
              let decoded = try? JSONDecoder().decode([Bike].self, from: data) else {
            return nil
        }
        return decoded
    }
}

enum SortOption: String, CaseIterable {
    case recommended = "Recommended"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
    case rating = "Rating"
}
