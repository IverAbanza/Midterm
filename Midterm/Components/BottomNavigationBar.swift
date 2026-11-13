import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selection: Int

    let items: [(title: String, icon: String)] = [
        ("Home", "house"),
        ("Shop", "bag"),
        ("Favorites", "heart"),
        ("Cart", "cart"),
        ("Profile", "person")
    ]

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                Button(action: {
                    selection = index
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: item.icon)
                            .font(.system(size: 18, weight: selection == index ? .bold : .regular))
                        Text(item.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(selection == index ? Color(red: 0.07, green: 0.11, blue: 0.21) : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.white.shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -4))
    }
}
