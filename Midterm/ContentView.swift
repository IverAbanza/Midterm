import SwiftUI

struct ContentView: View {
    @StateObject private var bikeController = BikeController()
    @StateObject private var cartController = CartController()
    @StateObject private var userController = UserController()
    @StateObject private var orderController = OrderController()

    @State private var currentTab = 0
    @State private var isShowingSignUp = false

    var body: some View {
        if userController.isLoggedIn && userController.isAdmin {
            AdminDashboardView(
                bikeController: bikeController,
                orderController: orderController,
                userController: userController,
                onLogout: {
                    userController.logout()
                }
            )
        } else if userController.isLoggedIn {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(0)
                    .tabItem { Label("Home", systemImage: "house.fill") }

                ShopView(bikeController: bikeController, cartController: cartController, userController: userController)
                    .tag(1)
                    .tabItem { Label("Shop", systemImage: "bag.fill") }

                FavoritesView(bikeController: bikeController, cartController: cartController, userController: userController)
                    .tag(2)
                    .tabItem { Label("Favorites", systemImage: "heart.fill") }

                CartView(cartController: cartController, bikeController: bikeController)
                    .tag(3)
                    .tabItem { Label("Cart", systemImage: "cart.fill") }

                SettingsView(userController: userController)
                    .tag(4)
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            }
            .accentColor(Color(red: 0.07, green: 0.11, blue: 0.21))
        } else if isShowingSignUp {
            SignUpView(
                userController: userController,
                onBackToLogin: {
                    isShowingSignUp = false
                },
                onSignUpSuccess: {
                    isShowingSignUp = false
                    userController.completeOnboarding()
                }
            )
        } else {
            LoginView(
                userController: userController,
                onLoginSuccess: {
                    userController.completeOnboarding()
                },
                onCreateAccount: {
                    isShowingSignUp = true
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
