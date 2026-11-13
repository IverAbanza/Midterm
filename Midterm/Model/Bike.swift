import Foundation

struct Bike: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let price: Double
    let imageName: String
    let description: String
}

let sampleBikes = [
    Bike(
        name: "Apex X1",
        type: "Mountain Bike",
        price: 24999,
        imageName: "bike1",
        description: "A powerful mountain bike designed for trails and off-road adventures."
    ),
    
    Bike(
        name: "Velocity S",
        type: "Road Bike",
        price: 32999,
        imageName: "bike2",
        description: "A lightweight road bike built for speed, distance, and smooth rides."
    ),
    
    Bike(
        name: "Urban Pro",
        type: "City Bike",
        price: 18999,
        imageName: "bike3",
        description: "A comfortable city bike perfect for everyday commuting."
    ),
    
    Bike(
        name: "Trail Master",
        type: "Mountain Bike",
        price: 28999,
        imageName: "bike4",
        description: "A durable trail bike made for challenging terrain and outdoor adventures."
    )
]
