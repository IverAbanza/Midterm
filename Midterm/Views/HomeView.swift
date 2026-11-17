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
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(AppTheme.navy)
                                .tracking(1.1)
                            Text("Ride Beyond Limits")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Button(action: {}) {
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

                            Text(sampleBikes[0].name)
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(.white)

                            Text(sampleBikes[0].type)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))

                            HStack {
                                Text("₱\(Int(sampleBikes[0].price))")
                                    .font(.system(size: 22, weight: .bold))
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
                            .foregroundStyle(.primary)

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
                            .foregroundStyle(AppTheme.navy)
                            .font(.system(size: 13, weight: .semibold))
                        }

                        ForEach(Array(sampleBikes.prefix(3)), id: \.id) { bike in
                            NavigationLink(destination: BikeDetailView(bike: bike)) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(bike.accent.opacity(0.16))
                                            .frame(width: 84, height: 84)
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundStyle(bike.accent)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bike.name)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(.primary)
                                        Text(bike.type)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(AppTheme.mutedText)
                                        Text("₱\(Int(bike.price))")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundStyle(AppTheme.navy)
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(AppTheme.mutedText)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 5)
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
            .background(title == "All" ? AppTheme.navy : AppTheme.card)
            .clipShape(Capsule())
            .shadow(color: title == "All" ? AppTheme.navy.opacity(0.14) : .clear, radius: 10, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
}
