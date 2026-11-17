import SwiftUI

struct HomeView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    @State private var selectedCategory = "All"
    @State private var selectedBike: Bike?
    @State private var showDetail = false
    @State private var showNotificationAlert = false

    private let categories = ["All", "Mountain", "Road", "Hybrid", "City"]

    var filteredFeatured: [Bike] {
        let list = bikeController.bikes.filter { selectedCategory == "All" ? true : $0.category == selectedCategory }
        return Array(list.prefix(3))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 22) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("BikeStore")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(AppTheme.navy)
                                    .tracking(1.1)
                                Text("Ride Beyond Limits")
                                    .font(.system(size: 30, weight: .heavy))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Button(action: { showNotificationAlert = true }) {
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(AppTheme.navy)
                                    .frame(width: 42, height: 42)
                                    .background(AppTheme.card)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
                            }
                        }

                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(LinearGradient(
                                    colors: [AppTheme.navy, AppTheme.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 230)

                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Featured bike")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.75))
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                        Text("4.8")
                                            .font(.system(size: 12, weight: .bold))
                                    }
                                    .foregroundStyle(.white)
                                }

                                Text(bikeController.bikes.first?.name ?? "No bikes available")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundStyle(.white)

                                Text(bikeController.bikes.first?.type ?? "")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.8))

                                HStack {
                                    Text("₱\(Int(bikeController.bikes.first?.price ?? 0))")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Button(action: {
                                        if let featuredBike = bikeController.bikes.first {
                                            selectedBike = featuredBike
                                            showDetail = true
                                        }
                                    }) {
                                        HStack {
                                            Text("Shop now")
                                                .font(.system(size: 13, weight: .bold))
                                            Image(systemName: "arrow.right")
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(.white.opacity(0.18))
                                        .foregroundStyle(.white)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(22)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.primary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(categories, id: \.self) { category in
                                        Button(action: { selectedCategory = category }) {
                                            CategoryButton(title: category, isSelected: selectedCategory == category)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Popular picks")
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                Button("See all") {
                                    selectedCategory = "All"
                                }
                                .foregroundStyle(AppTheme.navy)
                                .font(.system(size: 13, weight: .semibold))
                            }

                            ForEach(filteredFeatured, id: \.id) { bike in
                                PopularPickCard(
                                    bike: bike,
                                    onTap: {
                                        selectedBike = bike
                                        showDetail = true
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 18)
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("Home")
            .navigationDestination(isPresented: $showDetail) {
                if let bike = selectedBike {
                    BikeDetailView(bike: bike, bikeController: bikeController, cartController: cartController, userController: userController)
                }
            }
            .alert("Notifications", isPresented: $showNotificationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("You have 2 new bike alerts and 1 shipping update.")
            }
        }
    }
}

private struct PopularPickCard: View {
    let bike: Bike
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GeometryReader { proxy in
                let imageWidth = proxy.size.width * 0.38
                let infoWidth = max(proxy.size.width - imageWidth - 16 - 24, 0)

                HStack(alignment: .center, spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(AppTheme.lightBlue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        Image(bike.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth * 0.96, height: imageWidth * 0.82)
                            .padding(10)
                    }
                    .frame(width: imageWidth, height: 108)
                    .clipped()

                    VStack(alignment: .leading, spacing: 4) {
                        Text(bike.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .frame(maxWidth: infoWidth, alignment: .leading)

                        Text(bike.type)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
                            .lineLimit(1)
                            .frame(maxWidth: infoWidth, alignment: .leading)

                        Text("₱\(Int(bike.price))")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(AppTheme.navy)
                            .lineLimit(1)
                            .frame(maxWidth: infoWidth, alignment: .leading)

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.orange)
                            Text(String(format: "%.1f", bike.rating))
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: infoWidth, alignment: .leading)
                    }
                    .frame(width: infoWidth, alignment: .leading)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.mutedText)
                        .frame(width: 16, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 110)
            .padding(14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CategoryButton: View {
    let title: String
    var isSelected: Bool = false

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? AppTheme.navy : AppTheme.card)
            .clipShape(Capsule())
            .shadow(color: isSelected ? AppTheme.navy.opacity(0.14) : .clear, radius: 10, x: 0, y: 4)
    }
}

#Preview {
    HomeView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
}
