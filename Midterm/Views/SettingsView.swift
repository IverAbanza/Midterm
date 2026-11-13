import SwiftUI

struct SettingsView: View {
    @ObservedObject var userController: UserController

    @State private var pushNotifications = true
    @State private var orderUpdates = true
    @State private var darkMode = false
    @State private var locationAccess = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.07, green: 0.11, blue: 0.21).opacity(0.12))
                                .frame(width: 42, height: 42)
                            Image(systemName: "person.fill")
                                .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(userController.currentUser?.fullName ?? "BikeStore User")
                                .font(.system(size: 16, weight: .semibold))
                            Text(userController.currentUser?.email ?? "guest@bikestore.com")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Preferences") {
                    Toggle("Push notifications", isOn: $pushNotifications)
                    Toggle("Order updates", isOn: $orderUpdates)
                    Toggle("Dark mode", isOn: $darkMode)
                    Toggle("Location access", isOn: $locationAccess)
                }

                Section("Account actions") {
                    Button(role: .destructive) {
                        userController.logout()
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }

                Section("Support") {
                    Label("Help Center", systemImage: "questionmark.circle")
                    Label("Privacy Policy", systemImage: "shield.fill")
                    Label("Terms of Service", systemImage: "doc.text")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(userController: UserController())
}
