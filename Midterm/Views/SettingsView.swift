import SwiftUI

struct SettingsView: View {
    @ObservedObject var userController: UserController

    @State private var pushNotifications = true
    @State private var orderUpdates = true
    @State private var darkMode = false
    @State private var locationAccess = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.navy.opacity(0.12))
                                    .frame(width: 52, height: 52)
                                Image(systemName: "person.fill")
                                    .foregroundStyle(AppTheme.navy)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(userController.currentUser?.fullName ?? "BikeStore User")
                                    .font(.system(size: 18, weight: .bold))
                                Text(userController.currentUser?.email ?? "guest@bikestore.com")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }

                    settingsSection(title: "Preferences") {
                        ToggleRow(title: "Push notifications", isOn: $pushNotifications)
                        ToggleRow(title: "Order updates", isOn: $orderUpdates)
                        ToggleRow(title: "Dark mode", isOn: $darkMode)
                        ToggleRow(title: "Location access", isOn: $locationAccess)
                    }

                    settingsSection(title: "Support") {
                        SettingLinkRow(title: "Help Center", icon: "questionmark.circle")
                        SettingLinkRow(title: "Privacy Policy", icon: "shield.fill")
                        SettingLinkRow(title: "Terms of Service", icon: "doc.text")
                    }

                    Button(role: .destructive) {
                        userController.logout()
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.red.opacity(0.08))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(18)
            }
            .navigationTitle("Settings")
        }
    }

    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppTheme.navy)

            VStack(spacing: 0) {
                content()
            }
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }
}

private struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .overlay(
            Divider().padding(.leading), alignment: .bottom
        )
    }
}

private struct SettingLinkRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(AppTheme.navy)
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(AppTheme.mutedText)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .overlay(
            Divider().padding(.leading), alignment: .bottom
        )
    }
}

#Preview {
    SettingsView(userController: UserController())
}
