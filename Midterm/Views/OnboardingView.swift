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
                    .foregroundStyle(AppTheme.mutedText)
            }
            .padding(.horizontal)

            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 18) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(LinearGradient(colors: [AppTheme.navy, AppTheme.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 340)

                            Image(systemName: pages[index].icon)
                                .font(.system(size: 96, weight: .bold))
                                .foregroundStyle(.white)
                        }

                        Text(pages[index].title)
                            .font(.system(size: 30, weight: .bold))

                        Text(pages[index].subtitle)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
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
                        .fill(index == currentPage ? AppTheme.navy : Color.gray.opacity(0.3))
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
