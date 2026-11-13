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
                        Label("Name", systemImage: "person.fill")
                        Spacer()
                        Text(userController.currentUser?.fullName ?? "BikeStore User")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label("Email", systemImage: "envelope.fill")
                        Spacer()
                        Text(userController.currentUser?.email ?? "guest@bikestore.com")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Preferences") {
                    Toggle("Push notifications", isOn: $pushNotifications)
                    Toggle("Order updates", isOn: $orderUpdates)
                    Toggle("Dark mode", isOn: $darkMode)
                    Toggle("Location access", isOn: $locationAccess)
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
