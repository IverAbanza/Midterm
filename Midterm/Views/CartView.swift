import SwiftUI

struct CartView: View {
    
    @State private var quantity = 1
    
    let selectedBike = sampleBikes[0]
    
    var totalPrice: Double {
        selectedBike.price * Double(quantity)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    HStack(spacing: 15) {
                        
                        Image(systemName: "bicycle")
                            .font(.system(size: 45))
                            .frame(width: 85, height: 85)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 15)
                            )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(selectedBike.name)
                                .font(.headline)
                            
                            Text(selectedBike.type)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("₱\(Int(selectedBike.price))")
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )

                    HStack {
                        Text("Quantity")
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 35, height: 35)
                                .background(Color.gray.opacity(0.15))
                                .clipShape(Circle())
                        }
                        
                        Text("\(quantity)")
                            .fontWeight(.bold)
                            .frame(width: 30)
                        
                        Button {
                            quantity += 1
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 35, height: 35)
                                .background(Color.gray.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()

                    VStack(spacing: 15) {
                        Text("Order Summary")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Text("Subtotal")
                            
                            Spacer()
                            
                            Text("₱\(Int(totalPrice))")
                        }
                        
                        HStack {
                            Text("Delivery")
                            
                            Spacer()
                            
                            Text("FREE")
                                .fontWeight(.medium)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("₱\(Int(totalPrice))")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.08))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )

                    Button {
                        print("Checkout selected")
                    } label: {
                        Text("Proceed to Checkout")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.black)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Cart")
        }
    }
}

#Preview {
    CartView()
}
