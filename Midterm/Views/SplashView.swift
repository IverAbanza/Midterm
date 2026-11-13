import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.03, green: 0.11, blue: 0.34), Color(red: 0.07, green: 0.18, blue: 0.46)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 140, height: 140)

                    Image(systemName: "bicycle")
                        .font(.system(size: 62, weight: .bold))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
                }

                Text("BikeStore")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundStyle(.white)

                Text("Ride More. Live Better.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
