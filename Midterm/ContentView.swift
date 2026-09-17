import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ModelsView()
                .tabItem {
                    Label("Models", systemImage: "bicycle")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
