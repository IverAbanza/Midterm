import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
<<<<<<< HEAD
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
=======
            
            ModelsView()
                .tabItem {
                    Label("Models", systemImage: "bicycle")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
>>>>>>> parent of 65bfd55 (IverAbanzaFinalExam)
                }
        }
    }
}

#Preview {
    ContentView()
}
