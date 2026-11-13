import SwiftUI

struct SearchView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var query = ""
    @State private var category = "All"

    private let categories = ["All", "Road", "Mountain", "Hybrid"]

    var filtered: [Bike] {
        bikeController.filteredBikes(category: category, searchText: query)
    }

    var body: some View {
        VStack(spacing: 18) {
            SearchBar(text: $query, placeholder: "Search bikes")
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \ .self) { item in
                        Button(action: {
                            category = item
                        }) {
                            Text(item)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(category == item ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
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
                        ForEach(filtered, id: \ .id) { bike in
                            NavigationLink(destination: BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)) {
                                BikeCard(bike: bike) {
                                    print("Open bike")
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
    }
}
