import SwiftUI

enum AppTheme {
    static let navy = Color(red: 0.07, green: 0.11, blue: 0.21)
    static let blue = Color(red: 0.18, green: 0.38, blue: 0.93)
    static let lightBlue = Color(red: 0.92, green: 0.96, blue: 1.0)
    static let card = Color(.secondarySystemBackground)
    static let softGray = Color(.systemGray6)
    static let mutedText = Color.secondary
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.mutedText)
                .font(.system(size: 14, weight: .semibold))

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 3)
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppTheme.blue.opacity(0.1))
                    .frame(width: 88, height: 88)

                Image(systemName: systemImage)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(AppTheme.blue)
            }

            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.primary)

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.mutedText)
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [AppTheme.navy, AppTheme.blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: AppTheme.blue.opacity(0.25), radius: 12, x: 0, y: 10)
        }
    }
}

struct BikeCard: View {
    let bike: Bike
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(bike.accent.opacity(0.16))
                    .frame(height: 165)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10, weight: .bold))
                    Text(String(format: "%.1f", bike.rating))
                        .font(.system(size: 11, weight: .semibold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.22))
                .clipShape(Capsule())
                .padding(10)

                Image(systemName: "bicycle")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(bike.accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(bike.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)

                Text(bike.type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)

                HStack {
                    Text("₱\(Int(bike.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppTheme.navy)

                    Spacer()

                    Button(action: action) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(9)
                            .background(AppTheme.navy)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 8)
    }
}
