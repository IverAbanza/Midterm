import SwiftUI

struct BikeCardView: View {
    let bike: Bike
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "bicycle")
                .font(.system(size: 45))
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.12))
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(bike.name)
                    .font(.headline)
                
                Text(bike.type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("₱\(Int(bike.price))")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}

#Preview {
    BikeCardView(bike: sampleBikes[0])
}
