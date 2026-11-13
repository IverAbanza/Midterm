import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var orderController: OrderController
    @ObservedObject var userController: UserController
    let onLogout: () -> Void

    @State private var selectedTab = 0
    @State private var productSearch = ""
    @State private var orderSearch = ""
    @State private var productFilter = "All"
    @State private var orderFilter = "All"
    @State private var showingForm = false
    @State private var editingBike: Bike?
    @State private var draftName = ""
    @State private var draftType = "Road Bike"
    @State private var draftCategory = "Road"
    @State private var draftDescription = ""
    @State private var draftPrice = "2499"
    @State private var draftStock = "10"
    @State private var draftAccent = "#1264E8"

    private let statusOptions = ["All", "Pending", "Processing", "Shipped", "Completed", "Cancelled"]

    var filteredProducts: [Bike] {
        bikeController.bikes.filter { bike in
            let matchesSearch = productSearch.isEmpty || bike.name.lowercased().contains(productSearch.lowercased()) || bike.type.lowercased().contains(productSearch.lowercased())
            let matchesFilter = productFilter == "All" || bike.category == productFilter
            return matchesSearch && matchesFilter
        }
    }

    var filteredOrders: [Order] {
        orderController.orders.filter { order in
            let matchesSearch = orderSearch.isEmpty || order.customerName.lowercased().contains(orderSearch.lowercased()) || order.id.lowercased().contains(orderSearch.lowercased())
            let matchesFilter = orderFilter == "All" || order.status == orderFilter
            return matchesSearch && matchesFilter
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                header

                if selectedTab == 0 {
                    overviewView
                } else if selectedTab == 1 {
                    productsView
                } else if selectedTab == 2 {
                    ordersView
                } else {
                    customersView
                }
            }
            .padding(18)
            .sheet(isPresented: $showingForm) {
                productFormSheet
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Admin Console")
                    .font(.system(size: 28, weight: .heavy))
                Text("BikeStore Headquarters")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onLogout) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
    }

    private var overviewView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        MetricCard(title: "Revenue", value: "$\(Int(orderController.totalRevenue))", color: .green)
                        MetricCard(title: "Orders", value: "\(orderController.totalSales)", color: .blue)
                        MetricCard(title: "Customers", value: "\(userController.registeredCustomers().count)", color: .purple)
                        MetricCard(title: "Inventory", value: "\(bikeController.bikes.count)", color: .orange)
                    }
                    .padding(.horizontal, 2)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Operational overview")
                        .font(.system(size: 20, weight: .bold))
                    HStack(spacing: 12) {
                        MiniStat(title: "Pending", value: "\(orderController.pendingOrders.count)", color: .orange)
                        MiniStat(title: "Completed", value: "\(orderController.completedOrders.count)", color: .green)
                        MiniStat(title: "Low Stock", value: "\(bikeController.lowStockBikes().count)", color: .red)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent activity")
                        .font(.system(size: 20, weight: .bold))

                    ForEach(Array(orderController.orders.prefix(4).enumerated()), id: \.offset) { _, order in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(order.customerName)
                                    .font(.system(size: 15, weight: .semibold))
                                Text(order.id)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(order.status)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(order.status == "Completed" ? .green : .orange)
                                Text("$\(Int(order.total))")
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }
    }

    private var productsView: some View {
        VStack(spacing: 12) {
            HStack {
                SearchBar(text: $productSearch, placeholder: "Search products")
                Button(action: { openNewBikeForm() }) {
                    Image(systemName: "plus")
                        .frame(width: 42, height: 42)
                        .background(Color(red: 0.07, green: 0.11, blue: 0.21))
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }

            HStack {
                Picker("Filter", selection: $productFilter) {
                    let categories = ["All"] + bikeController.categories()
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                Spacer()
            }

            List(filteredProducts, id: \.id) { bike in
                HStack(alignment: .center, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(bike.accent.opacity(0.12))
                            .frame(width: 58, height: 58)
                        Image(systemName: "bicycle")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(bike.accent)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(bike.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(bike.category) • \(bike.stock) in stock")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        Text("$\(Int(bike.price))")
                            .font(.system(size: 13, weight: .bold))
                    }

                    Spacer()

                    Menu {
                        Button("Edit") { openEditForm(for: bike) }
                        Button("Delete", role: .destructive) { bikeController.deleteBike(id: bike.id) }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
        }
    }

    private var ordersView: some View {
        VStack(spacing: 12) {
            SearchBar(text: $orderSearch, placeholder: "Search orders")

            Picker("Status", selection: $orderFilter) {
                ForEach(statusOptions, id: \.self) { status in
                    Text(status).tag(status)
                }
            }
            .pickerStyle(.segmented)

            List(filteredOrders, id: \.id) { order in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(order.id)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        Text(order.status)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(statusColor(for: order.status).opacity(0.15))
                            .foregroundStyle(statusColor(for: order.status))
                            .clipShape(Capsule())
                    }
                    Text(order.customerName)
                        .foregroundStyle(.secondary)
                    Text("Items: \(order.items.count) • Total: $\(Int(order.total))")
                        .font(.system(size: 12, weight: .medium))

                    Menu {
                        ForEach(orderController.statusOptions(), id: \.self) { status in
                            Button(status) {
                                _ = orderController.updateStatus(orderId: order.id, to: status)
                            }
                        }
                    } label: {
                        Label("Update status", systemImage: "arrow.triangle.2.circlepath")
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
    }

    private var customersView: some View {
        List(userController.registeredCustomers(), id: \.id) { customer in
            VStack(alignment: .leading, spacing: 6) {
                Text(customer.fullName)
                    .font(.system(size: 16, weight: .semibold))
                Text(customer.email)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Text(customer.phone.isEmpty ? "No phone" : customer.phone)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .listStyle(.plain)
    }

    private func openNewBikeForm() {
        editingBike = nil
        draftName = ""
        draftType = "Road Bike"
        draftCategory = "Road"
        draftDescription = ""
        draftPrice = "2499"
        draftStock = "10"
        draftAccent = "#1264E8"
        showingForm = true
    }

    private func openEditForm(for bike: Bike) {
        editingBike = bike
        draftName = bike.name
        draftType = bike.type
        draftCategory = bike.category
        draftDescription = bike.description
        draftPrice = String(format: "%.0f", bike.price)
        draftStock = String(bike.stock)
        draftAccent = bike.accentColor
        showingForm = true
    }

    private var productFormSheet: some View {
        NavigationStack {
            Form {
                Section("Bike details") {
                    TextField("Name", text: $draftName)
                    TextField("Type", text: $draftType)
                    Picker("Category", selection: $draftCategory) {
                        ForEach(["Road", "Mountain", "Hybrid", "City"], id: \.self) { Text($0) }
                    }
                    TextField("Description", text: $draftDescription, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Price", text: $draftPrice)
                        .keyboardType(.numberPad)
                    TextField("Stock", text: $draftStock)
                        .keyboardType(.numberPad)
                }

                Section("Appearance") {
                    TextField("Accent HEX", text: $draftAccent)
                }
            }
            .navigationTitle(editingBike == nil ? "New bike" : "Edit bike")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showingForm = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProduct()
                    }
                }
            }
        }
    }

    private func saveProduct() {
        guard !draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let parsedPrice = Double(draftPrice), parsedPrice > 0 else { return }
        guard let parsedStock = Int(draftStock), parsedStock >= 0 else { return }

        let bike = Bike(
            id: editingBike?.id ?? UUID(),
            name: draftName,
            type: draftType,
            category: draftCategory,
            description: draftDescription.isEmpty ? "Premium bike from BikeStore." : draftDescription,
            price: parsedPrice,
            rating: editingBike?.rating ?? 4.7,
            reviewCount: editingBike?.reviewCount ?? 0,
            imageName: editingBike?.imageName ?? "bicycle",
            accentColor: draftAccent.hasPrefix("#") ? draftAccent : "#\(draftAccent)",
            sizes: editingBike?.sizes ?? ["M", "L", "XL"],
            colors: editingBike?.colors ?? ["Blue", "Black"],
            specs: editingBike?.specs ?? ["Frame": "Aluminum"],
            stock: parsedStock
        )

        if let editingBike {
            bikeController.updateBike(bike)
        } else {
            bikeController.addBike(bike)
        }
        showingForm = false
    }

    private func statusColor(for status: String) -> Color {
        switch status {
        case "Pending": return .orange
        case "Processing": return .blue
        case "Shipped": return .purple
        case "Completed": return .green
        case "Cancelled": return .red
        default: return .gray
        }
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 24, weight: .heavy))
        }
        .frame(width: 150, alignment: .leading)
        .padding()
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct MiniStat: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 22, weight: .heavy))
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    AdminDashboardView(
        bikeController: BikeController(),
        orderController: OrderController(),
        userController: UserController(),
        onLogout: {}
    )
}
