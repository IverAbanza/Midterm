import SwiftUI

struct ModelsView: View {
    let bikes = sampleBikes
    
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        
                        Text("Loading bike models...")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(bikes) { bike in
                                BikeCardView(bike: bike)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Bike Models")
            .task {
                try? await Task.sleep(for: .seconds(1))
                isLoading = false
            }
        }
    }
}

#Preview {
    ModelsView()
}
