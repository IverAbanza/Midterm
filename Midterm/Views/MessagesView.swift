import SwiftUI

struct MessagesView: View {
    private let items = [
        MessageItem(title: "BikeStore Support", preview: "Your order is on the way.", time: "2m ago", unread: 2),
        MessageItem(title: "Ride Specialist", preview: "Here are the best road bikes for your budget.", time: "11m ago", unread: 1),
        MessageItem(title: "Delivery Team", preview: "Your bike will arrive tomorrow morning.", time: "1h ago", unread: 0)
    ]

    var body: some View {
        NavigationStack {
            List(items) { item in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.navy.opacity(0.12))
                            .frame(width: 48, height: 48)
                        Image(systemName: "message.fill")
                            .foregroundStyle(AppTheme.navy)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.title)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text(item.time)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(AppTheme.mutedText)
                        }

                        Text(item.preview)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
                            .lineLimit(2)
                    }

                    if item.unread > 0 {
                        Text("\(item.unread)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .background(AppTheme.navy)
                            .clipShape(Circle())
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
        }
    }
}

private struct MessageItem: Identifiable {
    let id = UUID()
    let title: String
    let preview: String
    let time: String
    let unread: Int
}

#Preview {
    MessagesView()
}
