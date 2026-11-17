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

struct BikeArtwork: View {
    let bike: Bike
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(
                    colors: [bike.accent.opacity(0.24), bike.accent.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 170)

            Circle()
                .fill(.white.opacity(0.20))
                .frame(width: 118, height: 118)
                .offset(x: -30, y: 18)

            HStack(spacing: 28) {
                BikeWheel()
                BikeWheel()
            }
            .offset(y: 34)

            VStack(spacing: 0) {
                Capsule()
                    .fill(bike.accent)
                    .frame(width: 104, height: 6)
                    .rotationEffect(.degrees(-28))
                    .offset(x: 8, y: -12)

                Capsule()
                    .fill(bike.accent)
                    .frame(width: 90, height: 6)
                    .rotationEffect(.degrees(26))
                    .offset(x: 18, y: 10)

                Capsule()
                    .fill(bike.accent)
                    .frame(width: 110, height: 6)
                    .rotationEffect(.degrees(2))
                    .offset(x: 10, y: 10)

                Capsule()
                    .fill(bike.accent)
                    .frame(width: 54, height: 6)
                    .rotationEffect(.degrees(-72))
                    .offset(x: -10, y: 22)

                Capsule()
                    .fill(bike.accent)
                    .frame(width: 38, height: 6)
                    .rotationEffect(.degrees(-20))
                    .offset(x: 16, y: -8)
            }
            .frame(width: 160, height: 90)
            .offset(x: 0, y: -8)

            Circle()
                .fill(bike.accent)
                .frame(width: 14, height: 14)
                .offset(x: -16, y: -8)
        }
    }
}

private struct BikeWheel: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.10))
                .frame(width: 58, height: 58)

            Circle()
                .stroke(Color.white.opacity(0.70), lineWidth: 4)
                .frame(width: 58, height: 58)

            Circle()
                .fill(Color.clear)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.55), lineWidth: 2)
                )
        }
    }
}

struct BikeCard: View {
    let bike: Bike
    let onTap: () -> Void
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                BikeArtwork(bike: bike)

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
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
