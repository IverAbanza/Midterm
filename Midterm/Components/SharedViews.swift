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
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(
                    colors: [bike.accent.opacity(0.26), bike.accent.opacity(0.10), .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 170)
                .shadow(color: bike.accent.opacity(0.18), radius: 18, x: 0, y: 12)

            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 150, height: 150)
                .offset(x: -36, y: 20)

            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    BikeWheelVisual(color: bike.accent)
                        .frame(width: 74, height: 74)
                        .offset(x: -86, y: 46)

                    BikeWheelVisual(color: bike.accent)
                        .frame(width: 74, height: 74)
                        .offset(x: 86, y: 46)

                    BikeFrameVisual(color: bike.accent)
                        .frame(width: 220, height: 120)
                        .offset(y: -8)

                    Group {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.black.opacity(0.75))
                            .frame(width: 12, height: 52)
                            .offset(x: 28, y: -42)

                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.black.opacity(0.75))
                            .frame(width: 10, height: 42)
                            .rotationEffect(.degrees(18))
                            .offset(x: 72, y: -66)

                        Circle()
                            .fill(bike.accent)
                            .frame(width: 16, height: 16)
                            .offset(x: -18, y: -15)

                        Circle()
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 14, height: 14)
                            .offset(x: 32, y: -22)
                    }
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                }
            }
        }
    }
}

private struct BikeWheelVisual: View {
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.10))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Circle()
                .stroke(Color.black.opacity(0.75), lineWidth: 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Circle()
                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(12)

            ForEach(0..<8, id: \.self) { index in
                Rectangle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: 2, height: 20)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .offset(y: -22)
            }

            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
        }
    }
}

private struct BikeFrameVisual: View {
    let color: Color

    var body: some View {
        ZStack {
            Capsule()
                .fill(color)
                .frame(width: 118, height: 8)
                .rotationEffect(.degrees(-20))
                .offset(x: -8, y: -10)

            Capsule()
                .fill(color)
                .frame(width: 120, height: 8)
                .rotationEffect(.degrees(17))
                .offset(x: 18, y: 10)

            Capsule()
                .fill(color)
                .frame(width: 88, height: 8)
                .rotationEffect(.degrees(2))
                .offset(x: 8, y: 22)

            Capsule()
                .fill(color)
                .frame(width: 94, height: 8)
                .rotationEffect(.degrees(-52))
                .offset(x: -34, y: 12)

            Capsule()
                .fill(color)
                .frame(width: 78, height: 8)
                .rotationEffect(.degrees(62))
                .offset(x: 42, y: -6)

            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.black.opacity(0.72))
                .frame(width: 14, height: 56)
                .rotationEffect(.degrees(-20))
                .offset(x: -46, y: -48)

            Capsule()
                .fill(color)
                .frame(width: 124, height: 7)
                .rotationEffect(.degrees(82))
                .offset(x: 36, y: 23)

            Circle()
                .fill(color)
                .frame(width: 18, height: 18)
                .offset(x: -12, y: -12)

            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
                .offset(x: 52, y: 46)
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
