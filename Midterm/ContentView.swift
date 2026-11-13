import SwiftUI

struct ContentView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController
    @ObservedObject var orderController: OrderController

    @State private var showSplash = true
    @State private var currentTab = 0
    @State private var isShowingSignup = false

    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            showSplash = false
                        }
                    }
            } else if !userController.onboardingCompleted {
                OnboardingView(
                    onComplete: {
                        userController.completeOnboarding()
                    },
                    onSkip: {
                        userController.completeOnboarding()
                    }
                )
            } else if !userController.isLoggedIn {
                if isShowingSignup {
                    SignUpView(userController: userController, onBack: {
                        isShowingSignup = false
                    }, onSignedUp: {
                        userController.completeOnboarding()
                    })
                } else {
                    LoginView(userController: userController, onLoginSuccess: {
                        userController.completeOnboarding()
                    }, onCreateAccount: {
                        isShowingSignup = true
                    })
                }
            } else if userController.isAdmin {
                AdminDashboardView(
                    bikeController: bikeController,
                    orderController: orderController,
                    userController: userController,
                    onLogout: {
                        userController.logout()
                        currentTab = 0
                    }
                )
            } else {
                TabView(selection: $currentTab) {
                    HomeView(bikeController: bikeController, cartController: cartController, userController: userController)
                        .tag(0)
                        .tabItem { Label("Home", systemImage: "house") }

                    ShopView(bikeController: bikeController, cartController: cartController, userController: userController)
                        .tag(1)
                        .tabItem { Label("Shop", systemImage: "bag") }

                    FavoritesView(bikeController: bikeController, cartController: cartController, userController: userController)
                        .tag(2)
                        .tabItem { Label("Favorites", systemImage: "heart") }

                    MessagesView()
                        .tag(3)
                        .tabItem { Label("Messages", systemImage: "message.fill") }

                    CartView(bikeController: bikeController, cartController: cartController, orderController: orderController, userController: userController)
                        .tag(4)
                        .tabItem { Label("Cart", systemImage: "cart") }

                    SettingsView(userController: userController)
                        .tag(5)
                        .tabItem { Label("Settings", systemImage: "gearshape") }

                    ProfileView(
                        userController: userController,
                        orderController: orderController,
                        onLogout: {
                            userController.logout()
                            currentTab = 0
                        },
                        onEditProfile: {
                            currentTab = 6
                        },
                        onOpenOrders: {
                            currentTab = 6
                        },
                        onOpenFavorites: {
                            currentTab = 2
                        }
                    )
                    .tag(6)
                    .tabItem { Label("Profile", systemImage: "person") }
                }
                .accentColor(Color(red: 0.07, green: 0.11, blue: 0.21))
            }
        }
    }
}

#Preview {
    ContentView(
        bikeController: BikeController(),
        cartController: CartController(),
        userController: UserController(),
        orderController: OrderController()
    )
}
