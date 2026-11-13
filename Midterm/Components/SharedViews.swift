import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.system(size: 22, weight: .bold))
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
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
            .background(Color(red: 0.07, green: 0.11, blue: 0.21))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

struct BikeCard: View {
    let bike: Bike
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(bike.accent.opacity(0.16))
                    .frame(height: 160)

                Image(systemName: "bicycle")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(bike.accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(bike.name)
                    .font(.system(size: 16, weight: .bold))
                Text(bike.type)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                HStack {
                    Text("₱\(Int(bike.price))")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Button(action: action) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 8)
    }
}
