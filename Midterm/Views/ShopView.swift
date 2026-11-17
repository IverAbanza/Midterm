import SwiftUI

struct ShopView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedSort: SortOption = .recommended
    @State private var selectedBike: Bike?
    @State private var showDetail = false

    private let categories = ["All", "Road", "Mountain", "Hybrid"]

    var filteredBikes: [Bike] {
        bikeController.filteredBikes(category: selectedCategory, searchText: searchText, sortBy: selectedSort)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Shop")
                            .font(.system(size: 30, weight: .heavy))
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(AppTheme.navy)
                                .frame(width: 42, height: 42)
                                .background(AppTheme.card)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 3)
                        }
                    }

                    SearchBar(text: $searchText, placeholder: "Search bikes")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category)
                                        .font(.system(size: 13, weight: .semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 9)
                                        .background(selectedCategory == category ? AppTheme.navy : AppTheme.card)
                                        .foregroundStyle(selectedCategory == category ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }

                    HStack {
                        Text("\(filteredBikes.count) Bikes")
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                        Menu {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    selectedSort = option
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(selectedSort.rawValue)
                                    .font(.system(size: 12, weight: .semibold))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.card)
                            .clipShape(Capsule())
                        }
                    }

                    if filteredBikes.isEmpty {
                        EmptyStateView(title: "No bikes found", message: "Try another keyword or category.", systemImage: "magnifyingglass")
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                                ForEach(filteredBikes, id: \.id) { bike in
                                    BikeCard(
                                        bike: bike,
                                        onTap: {
                                            selectedBike = bike
                                            showDetail = true
                                        },
                                        action: {
                                            cartController.add(bike: bike)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(18)
                .navigationTitle("Shop")
            }
            .navigationDestination(isPresented: $showDetail) {
                if let bike = selectedBike {
                    BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShopView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
    }
}
