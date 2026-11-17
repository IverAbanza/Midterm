import SwiftUI

struct SearchView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var query = ""
    @State private var category = "All"
    @State private var selectedBike: Bike?
    @State private var showDetail = false

    private let categories = ["All", "Road", "Mountain", "Hybrid"]

    var filtered: [Bike] {
        bikeController.filteredBikes(category: category, searchText: query)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 18) {
                    SearchBar(text: $query, placeholder: "Search bikes")
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { item in
                                Button(action: {
                                    category = item
                                }) {
                                    Text(item)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(category == item ? AppTheme.navy : AppTheme.card)
                                        .foregroundStyle(category == item ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if filtered.isEmpty {
                        EmptyStateView(title: "No results found", message: "Try another search or category.", systemImage: "magnifyingglass")
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(filtered, id: \.id) { bike in
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
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showDetail) {
                if let bike = selectedBike {
                    BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
    }
}
