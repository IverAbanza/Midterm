import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 5) {
                        Text("VELOX")
                            .font(.system(size: 32, weight: .bold))
                        
                        Text("Ride Beyond Limits.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Bike")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Image(systemName: "bicycle")
                                .font(.system(size: 75))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 25)
                            
                            Text("Apex X1")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Mountain Bike")
                                .foregroundStyle(.secondary)
                            
                            Text("₱24,999")
                                .font(.headline)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 10) {
                            CategoryButton(title: "Mountain")
                            CategoryButton(title: "Road")
                            CategoryButton(title: "City")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct CategoryButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.15))
            .clipShape(Capsule())
    }
}

#Preview {
    HomeView()
}
