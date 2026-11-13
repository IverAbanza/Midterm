import SwiftUI

@main
struct BikeStoreApp: App {
    @StateObject private var bikeController = BikeController()
    @StateObject private var cartController = CartController()
    @StateObject private var userController = UserController()
    @StateObject private var orderController = OrderController()

    var body: some Scene {
        WindowGroup {
            ContentView(
                bikeController: bikeController,
                cartController: cartController,
                userController: userController,
                orderController: orderController
            )
        }
    }
}
