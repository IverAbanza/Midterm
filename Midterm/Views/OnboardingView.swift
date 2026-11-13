import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    let onSkip: () -> Void

    @State private var currentPage = 0
    private let pages: [(title: String, subtitle: String, icon: String)] = [
        ("Premium Bikes", "Ride performance bikes made for every adventure.", "bicycle"),
        ("Smart Shopping", "Browse, compare, and find the perfect fit for your ride.", "bag"),
        ("Track Your Order", "Follow purchases and manage your cycling lifestyle with ease.", "shippingbox")
    ]

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button("Skip", action: onSkip)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 18) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .fill(LinearGradient(colors: [Color(red: 0.07, green: 0.11, blue: 0.21), Color(red: 0.18, green: 0.39, blue: 0.90)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 340)

                            Image(systemName: pages[index].icon)
                                .font(.system(size: 96, weight: .bold))
                                .foregroundStyle(.white)
                        }

                        Text(pages[index].title)
                            .font(.system(size: 30, weight: .bold))

                        Text(pages[index].subtitle)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 10) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }

            PrimaryButton(title: currentPage == pages.count - 1 ? "Get Started" : "Next", icon: currentPage == pages.count - 1 ? "arrow.right" : "chevron.right") {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    onComplete()
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

#Preview {
    OnboardingView(onComplete: {}, onSkip: {})
}
