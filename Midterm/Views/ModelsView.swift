import SwiftUI

struct ModelsView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var cartController: CartController
    @ObservedObject var userController: UserController

    var body: some View {
        ShopView(bikeController: bikeController, cartController: cartController, userController: userController)
    }
}

#Preview {
    ModelsView(bikeController: BikeController(), cartController: CartController(), userController: UserController())
}
