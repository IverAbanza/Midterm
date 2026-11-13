import Foundation
import Combine

final class BikeController: ObservableObject {
    @Published var bikes: [Bike]

    init() {
        self.bikes = sampleBikes
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
}

enum SortOption: String, CaseIterable {
    case recommended = "Recommended"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
    case rating = "Rating"
}
