import SwiftUI

struct HomeView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedSort: SortOption = .recommended
    @State private var navigateToSearch = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, \(userController.currentUser?.fullName.components(separatedBy: " ").first ?? "Rider")!")
                                .font(.system(size: 26, weight: .bold))
                            Text("Find your next ride")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.system(size: 22))
                                .foregroundStyle(.primary)
                                .frame(width: 42, height: 42)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }

                    SearchBar(text: $searchText, placeholder: "Search bikes")
                        .onTapGesture { navigateToSearch = true }

                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(colors: [Color(red: 0.07, green: 0.11, blue: 0.21), Color(red: 0.18, green: 0.39, blue: 0.90)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 182)

                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Summer Sale")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.8))
                                Text("Up to 50% OFF")
                                    .font(.system(size: 30, weight: .heavy))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            Image(systemName: "bicycle")
                                .font(.system(size: 72, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .padding()
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Categories")
                            .font(.system(size: 22, weight: .bold))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                CategoryCard(title: "All", icon: "bicycle", isSelected: selectedCategory == "All") {
                                    selectedCategory = "All"
                                }
                                CategoryCard(title: "Road", icon: "speedometer", isSelected: selectedCategory == "Road") {
                                    selectedCategory = "Road"
                                }
                                CategoryCard(title: "Mountain", icon: "mountain.2", isSelected: selectedCategory == "Mountain") {
                                    selectedCategory = "Mountain"
                                }
                                CategoryCard(title: "Hybrid", icon: "sparkles", isSelected: selectedCategory == "Hybrid") {
                                    selectedCategory = "Hybrid"
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Featured Bikes")
                            .font(.system(size: 22, weight: .bold))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(bikeController.filteredBikes(category: selectedCategory, searchText: searchText, sortBy: selectedSort).prefix(3), id: \.id) { bike in
                                    NavigationLink(destination: BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)) {
                                        BikeCard(bike: bike) {
                                            print("Open bike")
                                        }
                                        .frame(width: 230)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Best Sellers")
                            .font(.system(size: 22, weight: .bold))

                        LazyVStack(spacing: 14) {
                            ForEach(bikeController.filteredBikes(category: selectedCategory, searchText: searchText, sortBy: .rating).prefix(3), id: \.id) { bike in
                                NavigationLink(destination: BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(bike.accent.opacity(0.12))
                                                .frame(width: 84, height: 84)
                                            Image(systemName: "bicycle")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundStyle(bike.accent)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(bike.name)
                                                .font(.system(size: 16, weight: .bold))
                                            Text(bike.type)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundStyle(.secondary)
                                            HStack {
                                                RatingView(rating: bike.rating, starSize: 12)
                                                Text("(\(bike.reviewCount))")
                                                    .font(.system(size: 11))
                                                    .foregroundStyle(.secondary)
                                            }
                                        }

                                        Spacer()

                                        Text("$\(Int(bike.price))")
                                            .font(.system(size: 18, weight: .heavy))
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 5)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(18)
            }
            .navigationDestination(isPresented: $navigateToSearch) {
                SearchView(bikeController: bikeController, cartController: cartController, userController: userController)
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    HomeView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
}
