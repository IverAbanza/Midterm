import SwiftUI

struct FavoritesView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    var favoriteBikes: [Bike] {
        let favoriteIds = UserDefaults.standard.array(forKey: "bikeStore.favorites") as? [String] ?? []
        return bikeController.bikes.filter { bike in
            favoriteIds.contains(bike.id.uuidString)
        }
    }

    var body: some View {
        NavigationStack {
            if favoriteBikes.isEmpty {
                EmptyStateView(title: "No favorites yet", message: "Save your favorite bicycles to compare later.", systemImage: "heart")
                    .navigationTitle("Favorites")
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(favoriteBikes, id: \.id) { bike in
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(bike.accent.opacity(0.12))
                                        .frame(width: 72, height: 72)
                                    Image(systemName: "bicycle")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(bike.accent)
                                }

                                VStack(alignment: .leading) {
                                    Text(bike.name)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(bike.type)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text("$\(Int(bike.price))")
                                        .font(.system(size: 17, weight: .heavy))
                                }

                                Spacer()

                                Button(action: {
                                    cartController.add(bike: bike)
                                }) {
                                    Image(systemName: "cart.fill")
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorites")
            }
        }
    }
}

#Preview {
    FavoritesView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
}
