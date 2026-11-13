import SwiftUI

struct ProfileView: View {
    @ObservedObject var userController: UserController
    @ObservedObject var orderController: OrderController

    let onLogout: () -> Void
    let onEditProfile: () -> Void
    let onOpenOrders: () -> Void
    let onOpenFavorites: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.07, green: 0.11, blue: 0.21).opacity(0.12))
                                .frame(width: 86, height: 86)
                            Image(systemName: "person.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                        }

                        VStack(alignment: .leading) {
                            Text(userController.currentUser?.fullName ?? "Guest Rider")
                                .font(.system(size: 24, weight: .bold))
                            Text(userController.currentUser?.email ?? "guest@bikestore.com")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ProfileMenuRow(title: "My Orders", icon: "shippingbox", action: onOpenOrders)
                        ProfileMenuRow(title: "Favorites", icon: "heart", action: onOpenFavorites)
                        ProfileMenuRow(title: "Addresses", icon: "location", action: {})
                        ProfileMenuRow(title: "Payment Methods", icon: "creditcard", action: {})
                        ProfileMenuRow(title: "Settings", icon: "gearshape", action: {})
                        ProfileMenuRow(title: "Help & Support", icon: "questionmark.circle", action: {})
                    }

                    Button(action: onEditProfile) {
                        Text("Edit Profile")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: onLogout) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.red)
                            .background(Color.red.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileMenuRow: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView(userController: UserController(), orderController: OrderController(), onLogout: {}, onEditProfile: {}, onOpenOrders: {}, onOpenFavorites: {})
}
