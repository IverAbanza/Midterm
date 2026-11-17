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
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(bike.accent.opacity(0.12))
                                        .frame(width: 74, height: 74)
                                    Image(systemName: "bicycle")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(bike.accent)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(bike.name)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(bike.type)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(AppTheme.mutedText)
                                    Text("$\(Int(bike.price))")
                                        .font(.system(size: 17, weight: .heavy))
                                        .foregroundStyle(AppTheme.navy)
                                }

                                Spacer()

                                Button(action: {
                                    cartController.add(bike: bike)
                                }) {
                                    Image(systemName: "cart.fill")
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .background(AppTheme.navy)
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 4)
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
