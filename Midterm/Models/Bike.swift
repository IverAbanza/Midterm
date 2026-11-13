import Foundation
import SwiftUI
import Combine

struct Bike: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let type: String
    let category: String
    let description: String
    let price: Double
    let rating: Double
    let reviewCount: Int
    let imageName: String
    let accentColor: String
    let sizes: [String]
    let colors: [String]
    let specs: [String: String]

    var accent: Color {
        Color(hex: accentColor)
    }
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        Scanner(string: value).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

let sampleBikes: [Bike] = [
    Bike(
        id: UUID(),
        name: "Trek Domane SL 6",
        type: "Road Bike",
        category: "Road",
        description: "Performance-focused road bike built for endurance, comfort, and smooth acceleration across long rides and climbs.",
        price: 2499,
        rating: 4.8,
        reviewCount: 120,
        imageName: "road-bicycle",
        accentColor: "#1264E8",
        sizes: ["52cm", "54cm", "56cm", "58cm"],
        colors: ["Blue", "Black", "Silver"],
        specs: [
            "Frame": "Carbon",
            "Gears": "Shimano 105",
            "Wheel": "700c",
            "Weight": "8.2 kg"
        ]
    ),
    Bike(
        id: UUID(),
        name: "Giant TCR Advanced",
        type: "Road Bike",
        category: "Road",
        description: "A lightweight racing machine designed for speed, stability, and everyday road confidence.",
        price: 2099,
        rating: 4.7,
        reviewCount: 94,
        imageName: "road-racer",
        accentColor: "#318BFF",
        sizes: ["50cm", "52cm", "54cm"],
        colors: ["Navy", "Red", "White"],
        specs: [
            "Frame": "Advanced Composite",
            "Gears": "Shimano 105",
            "Wheel": "700c",
            "Weight": "8.6 kg"
        ]
    ),
    Bike(
        id: UUID(),
        name: "Cannondale SuperSix",
        type: "Performance Bike",
        category: "Road",
        description: "Highly responsive and efficient, making it ideal for confident riders chasing speed and control.",
        price: 3399,
        rating: 4.9,
        reviewCount: 148,
        imageName: "speed-bike",
        accentColor: "#071B36",
        sizes: ["54cm", "56cm", "58cm", "60cm"],
        colors: ["Black", "Blue", "Gray"],
        specs: [
            "Frame": "Carbon",
            "Gears": "Ultegra",
            "Wheel": "700c",
            "Weight": "7.9 kg"
        ]
    ),
    Bike(
        id: UUID(),
        name: "Specialized Allez",
        type: "Hybrid Bike",
        category: "Hybrid",
        description: "A balanced hybrid for city riding, recreational commutes, and smooth multi-surface adventures.",
        price: 1899,
        rating: 4.6,
        reviewCount: 76,
        imageName: "hybrid-bike",
        accentColor: "#318BFF",
        sizes: ["M", "L", "XL"],
        colors: ["Blue", "White", "Orange"],
        specs: [
            "Frame": "Aluminum",
            "Gears": "Shimano Altus",
            "Wheel": "700c",
            "Weight": "9.6 kg"
        ]
    ),
    Bike(
        id: UUID(),
        name: "Santa Cruz Hightower",
        type: "Mountain Bike",
        category: "Mountain",
        description: "Trail-ready mountain bike built for rough terrain, aggressive climbs, and confident descents.",
        price: 2899,
        rating: 4.8,
        reviewCount: 132,
        imageName: "mountain-bike",
        accentColor: "#1264E8",
        sizes: ["S", "M", "L", "XL"],
        colors: ["Red", "Black", "Green"],
        specs: [
            "Frame": "Carbon",
            "Gears": "Shimano Deore",
            "Wheel": "29\"",
            "Weight": "12.8 kg"
        ]
    ),
    Bike(
        id: UUID(),
        name: "Orbea Oiz",
        type: "Mountain Bike",
        category: "Mountain",
        description: "Technical trail bike with excellent traction and stability for demanding off-road sessions.",
        price: 3199,
        rating: 4.9,
        reviewCount: 88,
        imageName: "trail-bike",
        accentColor: "#071B36",
        sizes: ["S", "M", "L"],
        colors: ["Gray", "Black", "Blue"],
        specs: [
            "Frame": "Carbon",
            "Gears": "XT",
            "Wheel": "29\"",
            "Weight": "12.2 kg"
        ]
    )
]
