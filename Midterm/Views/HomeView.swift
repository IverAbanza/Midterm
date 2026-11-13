import SwiftUI

struct HomeView: View {
    private let categories = ["All", "Mountain", "Road", "Hybrid", "City"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("BikeStore")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                            Text("Ride Beyond Limits")
                                .font(.system(size: 28, weight: .heavy))
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }

                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(LinearGradient(
                                colors: [Color(red: 0.07, green: 0.11, blue: 0.21), Color(red: 0.19, green: 0.38, blue: 0.93)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 220)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Featured bike")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.75))

                            Text(sampleBikes[0].name)
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(.white)

                            Text(sampleBikes[0].type)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))

                            HStack {
                                Text("₱\(Int(sampleBikes[0].price))")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Button(action: {}) {
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

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categories, id: \.self) { category in
                                    CategoryButton(title: category)
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
                            }
                            .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                            .font(.system(size: 13, weight: .semibold))
                        }

                        ForEach(Array(sampleBikes.prefix(3)), id: \.id) { bike in
                            NavigationLink(destination: BikeDetailView(bike: bike)) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(bike.accent.opacity(0.18))
                                            .frame(width: 84, height: 84)
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundStyle(bike.accent)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bike.name)
                                            .font(.system(size: 16, weight: .bold))
                                        Text(bike.type)
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                        Text("₱\(Int(bike.price))")
                                            .font(.system(size: 15, weight: .bold))
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(18)
            }
            .navigationTitle("Home")
        }
    }
}

struct CategoryButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(title == "All" ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(title == "All" ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
            .clipShape(Capsule())
    }
}

#Preview {
    HomeView()
}
