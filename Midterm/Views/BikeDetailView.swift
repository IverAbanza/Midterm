import SwiftUI

struct BikeDetailView: View {
    let bike: Bike
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Image(systemName: "bicycle")
                    .font(.system(size: 110))
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .background(Color.gray.opacity(0.12))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(bike.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(bike.type)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("₱\(Int(bike.price))")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("About this bike")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(bike.description)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }

<<<<<<< HEAD
                VStack(alignment: .leading, spacing: 10) {
                    Text("Available colors")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 12) {
                        ForEach(bike.colors, id: \.self) { colorName in
                            Button(action: { selectedColor = colorName }) {
                                Text(colorName)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedColor == colorName ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
                                    .foregroundStyle(selectedColor == colorName ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Sizes")
                        .font(.system(size: 18, weight: .bold))

                    HStack(spacing: 10) {
                        ForEach(bike.sizes, id: \.self) { size in
                            Button(action: { selectedSize = size }) {
                                Text(size)
                                    .frame(width: 52, height: 36)
                                    .background(selectedSize == size ? Color(red: 0.07, green: 0.11, blue: 0.21) : Color(.systemGray6))
                                    .foregroundStyle(selectedSize == size ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
=======
                VStack(alignment: .leading, spacing: 12) {
>>>>>>> parent of 65bfd55 (IverAbanzaFinalExam)
                    Text("Specifications")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    SpecificationRow(
                        icon: "bicycle",
                        title: "Bike Type",
                        value: bike.type
                    )
                    
                    SpecificationRow(
                        icon: "gearshape.fill",
                        title: "Gears",
                        value: "18-Speed"
                    )
                    
                    SpecificationRow(
                        icon: "circle.circle",
                        title: "Wheel Size",
                        value: "29 inches"
                    )
                    
                    SpecificationRow(
                        icon: "scalemass.fill",
                        title: "Weight",
                        value: "12.5 kg"
                    )
                }

<<<<<<< HEAD
                    VStack(spacing: 10) {
                        ForEach(Array(bike.specs.keys.sorted()), id: \.self) { key in
                            HStack {
                                Text(key)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(bike.specs[key] ?? "")
                                    .fontWeight(.semibold)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
=======
                Button {
                    print("\(bike.name) added to cart")
                } label: {
                    HStack {
                        Image(systemName: "cart.fill")
                        
                        Text("Add to Cart")
                            .fontWeight(.bold)
>>>>>>> parent of 65bfd55 (IverAbanzaFinalExam)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.black)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle("Bike Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
    

struct SpecificationRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    NavigationStack {
        BikeDetailView(bike: sampleBikes[0])
    }
}
