import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var bikeController: BikeController
    @ObservedObject var orderController: OrderController
    @ObservedObject var userController: UserController
    let onLogout: () -> Void

    @State private var selectedTab = 0
    @State private var productSearch = ""
    @State private var orderSearch = ""
    @State private var customerSearch = ""
    @State private var productFilter = "All"
    @State private var stockFilter = "All"
    @State private var orderFilter = "All"
    @State private var showingForm = false
    @State private var productFormError = ""
    @State private var showProductFormError = false
    @State private var showRevenueDetail = false
    @State private var selectedOrderDetail: Order? = nil
    @State private var selectedProductDetail: Bike? = nil
    @State private var selectedCustomerDetail: User? = nil
    @State private var deleteTargetId: UUID? = nil
    @State private var showDeleteConfirm = false

    private let tabs = ["Overview", "Inventory", "Orders", "Customers"]
    @State private var editingBike: Bike?
    @State private var draftName = ""
    @State private var draftType = "Road Bike"
    @State private var draftCategory = "Road"
    @State private var draftDescription = ""
    @State private var draftPrice = "2499"
    @State private var draftStock = "10"
    @State private var draftAccent = "#1264E8"

    private let statusOptions = ["All", "Pending", "Processing", "Shipped", "Completed", "Cancelled"]

    private var inventoryFilters: [String] {
        ["All", "In Stock", "Low Stock", "Out of Stock"]
    }

    var filteredProducts: [Bike] {
        bikeController.bikes.filter { bike in
            let matchesSearch = productSearch.isEmpty || bike.name.lowercased().contains(productSearch.lowercased()) || bike.type.lowercased().contains(productSearch.lowercased())
            let matchesCategory = productFilter == "All" || bike.category == productFilter
            let matchesStock: Bool
            switch stockFilter {
            case "In Stock": matchesStock = bike.stock > 5
            case "Low Stock": matchesStock = bike.stock > 0 && bike.stock <= 5
            case "Out of Stock": matchesStock = bike.stock == 0
            default: matchesStock = true
            }
            return matchesSearch && matchesCategory && matchesStock
        }
    }

    var filteredOrders: [Order] {
        orderController.orders.filter { order in
            let matchesSearch = orderSearch.isEmpty || order.customerName.lowercased().contains(orderSearch.lowercased()) || order.id.lowercased().contains(orderSearch.lowercased())
            let matchesFilter = orderFilter == "All" || order.status == orderFilter
            return matchesSearch && matchesFilter
        }
    }

    var filteredCustomers: [User] {
        userController.registeredCustomers().filter { customer in
            customerSearch.isEmpty || customer.fullName.lowercased().contains(customerSearch.lowercased()) || customer.email.lowercased().contains(customerSearch.lowercased())
        }
    }

    var revenueTrendData: [(label: String, value: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let days = (0..<7).reversed().map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today) ?? today
        }

        return days.map { date in
            let total = orderController.orders.filter {
                calendar.isDate($0.createdAt, inSameDayAs: date)
            }.reduce(0.0) { $0 + $1.total }
            let label = date.formatted(.dateTime.day().month(.abbreviated))
            return (label, total)
        }
    }

    var lowStockProducts: [Bike] {
        bikeController.lowStockBikes()
    }

    var recentOrders: [Order] {
        Array(orderController.orders.prefix(4))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                header

                HStack(spacing: 8) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                        Button(action: { selectedTab = index }) {
                            Text(title)
                                .font(.system(size: 12, weight: selectedTab == index ? .bold : .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(selectedTab == index ? .white : AppTheme.mutedText)
                                .background(selectedTab == index ? AppTheme.navy : Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }

                Group {
                    switch selectedTab {
                    case 0:
                        overviewView
                    case 1:
                        productsView
                    case 2:
                        ordersView
                    default:
                        customersView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(18)
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showingForm) {
                productFormSheet
            }
            .sheet(isPresented: $showRevenueDetail) {
                RevenueDetailSheet(orders: orderController.orders)
            }
            .sheet(item: $selectedOrderDetail) { order in
                OrderDetailSheet(order: order, onStatusChange: { newStatus in
                    _ = orderController.updateStatus(orderId: order.id, to: newStatus)
                })
            }
            .sheet(item: $selectedProductDetail) { bike in
                ProductDetailSheet(bike: bike, onEdit: { openEditForm(for: bike) }, onDelete: {
                    deleteTargetId = bike.id
                    showDeleteConfirm = true
                })
            }
            .sheet(item: $selectedCustomerDetail) { customer in
                CustomerDetailSheet(customer: customer, orders: orderController.orders.filter { $0.customerName == customer.fullName })
            }
            .alert("Delete product", isPresented: $showDeleteConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let id = deleteTargetId {
                        bikeController.deleteBike(id: id)
                        deleteTargetId = nil
                    }
                }
            } message: {
                Text("This will permanently remove the selected bike from inventory.")
            }
            .alert("Product validation", isPresented: $showProductFormError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(productFormError)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Admin Console")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(AppTheme.navy)
                Text("BikeStore Headquarters")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.navy.opacity(0.1))
                    .frame(width: 42, height: 42)
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(AppTheme.navy)
                    .font(.system(size: 22, weight: .semibold))
            }

            Button(action: onLogout) {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(height: 38)
                    .foregroundStyle(.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var overviewView: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    StatCard(
                        title: "Total Revenue",
                        value: formatCurrency(orderController.totalRevenue),
                        icon: "dollarsign.circle.fill",
                        color: .blue,
                        action: {
                            showRevenueDetail = true
                        }
                    )
                    StatCard(
                        title: "Total Orders",
                        value: "\(orderController.totalSales)",
                        icon: "bag.fill",
                        color: .green,
                        action: {
                            selectedTab = 2
                            orderFilter = "All"
                        }
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Operational overview", subtitle: "Live store status")

                    HStack(spacing: 12) {
                        OperationCard(title: "Pending", value: "\(orderController.pendingOrders.count)", accent: .orange, icon: "clock.fill") {
                            selectedTab = 2
                            orderFilter = "Pending"
                        }
                        OperationCard(title: "Completed", value: "\(orderController.completedOrders.count)", accent: .green, icon: "checkmark.seal.fill") {
                            selectedTab = 2
                            orderFilter = "Completed"
                        }
                        OperationCard(title: "Low Stock", value: "\(lowStockProducts.count)", accent: .red, icon: "exclamationmark.triangle.fill") {
                            selectedTab = 1
                            stockFilter = "Low Stock"
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Revenue overview", subtitle: "Last 7 days")
                    RevenueChartView(data: revenueTrendData)
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Recent orders", subtitle: "Latest activity")

                    if recentOrders.isEmpty {
                        EmptyStateView(title: "No orders yet", message: "Orders will appear here when customers place them.", systemImage: "shippingbox")
                    } else {
                        ForEach(recentOrders, id: \.id) { order in
                            OrderRowCard(order: order, statusColor: statusColor(for: order.status))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Inventory alerts", subtitle: "Watchlist")

                    if lowStockProducts.isEmpty {
                        EmptyStateView(title: "Inventory healthy", message: "No bikes are currently running low on stock.", systemImage: "checkmark.circle.fill")
                    } else {
                        ForEach(lowStockProducts.prefix(3), id: \.id) { bike in
                            Button(action: {
                                selectedTab = 1
                                productFilter = bike.category
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(bike.accent.opacity(0.14))
                                            .frame(width: 46, height: 46)
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(bike.accent)
                                    }

                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(bike.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.primary)
                                        Text("\(bike.stock) left in stock")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(AppTheme.mutedText)
                                    }

                                    Spacer()

                                    Text("Low")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background(Color.red)
                                        .clipShape(Capsule())
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Quick actions", subtitle: "Management shortcuts")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        QuickActionCard(icon: "plus.circle.fill", title: "Add Product", accent: AppTheme.blue) {
                            openNewBikeForm()
                        }
                        QuickActionCard(icon: "shippingbox.fill", title: "View Orders", accent: .green) {
                            selectedTab = 2
                        }
                        QuickActionCard(icon: "cube.box.fill", title: "Manage Inventory", accent: .orange) {
                            selectedTab = 1
                        }
                        QuickActionCard(icon: "person.2.fill", title: "View Customers", accent: .purple) {
                            selectedTab = 3
                        }
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }

    private var productsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SearchBar(text: $productSearch, placeholder: "Search products")
                Button(action: { openNewBikeForm() }) {
                    Image(systemName: "plus")
                        .frame(width: 42, height: 42)
                        .background(AppTheme.navy)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }

            HStack(spacing: 10) {
                Picker("Category", selection: $productFilter) {
                    let categories = ["All"] + bikeController.categories()
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)

                Picker("Stock", selection: $stockFilter) {
                    ForEach(inventoryFilters, id: \.self) { filter in
                        Text(filter).tag(filter)
                    }
                }
                .pickerStyle(.menu)
            }

            if filteredProducts.isEmpty {
                EmptyStateView(title: "No products found", message: "Try changing your search or stock filter.", systemImage: "magnifyingglass")
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredProducts, id: \.id) { bike in
                            ProductRowCard(bike: bike, onEdit: { openEditForm(for: bike) }, onDelete: { bikeController.deleteBike(id: bike.id) })
                        }
                    }
                }
            }
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

            if filteredOrders.isEmpty {
                EmptyStateView(title: "No matching orders", message: "No orders match the selected filters.", systemImage: "shippingbox")
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredOrders, id: \.id) { order in
                            OrderManagementCard(order: order, onStatusSelected: { newStatus in
                                let previousStatus = order.status
                                if newStatus == "Cancelled" && previousStatus != "Cancelled" {
                                    for item in order.items {
                                        bikeController.restoreStock(for: item.bikeId, quantity: item.quantity)
                                    }
                                }
                                _ = orderController.updateStatus(orderId: order.id, to: newStatus)
                            })
                        }
                    }
                }
            }
        }
    }

    private var customersView: some View {
        VStack(spacing: 12) {
            SearchBar(text: $customerSearch, placeholder: "Search customers")

            if filteredCustomers.isEmpty {
                EmptyStateView(title: "No customers yet", message: "Customer profiles will appear here.", systemImage: "person.2.fill")
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredCustomers, id: \.id) { customer in
                            Button(action: {
                                selectedCustomerDetail = customer
                            }) {
                                CustomerCard(customer: customer, orders: orderController.orders.filter { $0.customerName == customer.fullName })
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
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
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(editingBike == nil ? "New bike" : "Edit bike")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showingForm = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveProduct() }
                }
            }
        }
    }

    private func saveProduct() {
        let cleanedName = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPrice = draftPrice.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedStock = draftStock.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedName.isEmpty else {
            productFormError = "Product name is required."
            showProductFormError = true
            return
        }

        guard let parsedPrice = Double(cleanedPrice), parsedPrice > 0 else {
            productFormError = "Price must be a positive number."
            showProductFormError = true
            return
        }

        guard let parsedStock = Int(cleanedStock), parsedStock >= 0 else {
            productFormError = "Stock must be a valid non-negative number."
            showProductFormError = true
            return
        }

        let bike = Bike(
            id: editingBike?.id ?? UUID(),
            name: cleanedName,
            type: draftType.isEmpty ? "Road Bike" : draftType,
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

        if editingBike != nil {
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

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_PH")
        formatter.numberStyle = .currency
        formatter.currencyCode = "PHP"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "₱0"
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppTheme.navy)
            Spacer()
            Text(subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppTheme.mutedText)
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(color)
                    Spacer()
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.mutedText)
                }

                Text(value)
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundStyle(AppTheme.navy)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

private struct OperationCard: View {
    let title: String
    let value: String
    let accent: Color
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(accent)
                    Spacer()
                    Text(value)
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(AppTheme.navy)
                }
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppTheme.mutedText)
            }
            .frame(maxWidth: .infinity, minHeight: 92)
            .padding(14)
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

private struct RevenueChartView: View {
    let data: [(label: String, value: Double)]

    var maxValue: Double {
        max(data.reduce(0.0) { max($0, $1.value) }, 1.0)
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(data, id: \.label) { item in
                    VStack(spacing: 6) {
                        ZStack(alignment: .bottom) {
                            Capsule()
                                .fill(Color(.systemGray5))
                                .frame(width: 18, height: 120)
                            Capsule()
                                .fill(LinearGradient(colors: [AppTheme.blue, AppTheme.navy], startPoint: .bottom, endPoint: .top))
                                .frame(width: 18, height: max(10, (item.value / maxValue) * 110))
                        }
                        .frame(height: 120)

                        Text(item.label)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(AppTheme.mutedText)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
    }
}

private struct OrderRowCard: View {
    let order: Order
    let statusColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.12))
                    .frame(width: 42, height: 42)
                Image(systemName: "bag.fill")
                    .foregroundStyle(statusColor)
                    .font(.system(size: 16, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(order.customerName)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(order.status)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(statusColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(statusColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                Text(order.id)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
                Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
                HStack {
                    Text("Total")
                        .foregroundStyle(AppTheme.mutedText)
                    Spacer()
                    Text("₱\(Int(order.total))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppTheme.navy)
                }
            }
        }
        .padding(12)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

private struct QuickActionCard: View {
    let icon: String
    let title: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(accent)
                    .frame(width: 42, height: 42)
                    .background(accent.opacity(0.12))
                    .clipShape(Circle())
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.navy)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

private struct ProductRowCard: View {
    let bike: Bike
    let onEdit: () -> Void
    let onDelete: () -> Void

    var stockStyle: Color {
        if bike.stock == 0 { return .red }
        if bike.stock <= 5 { return .orange }
        return .green
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(bike.accent.opacity(0.14))
                    .frame(width: 56, height: 56)
                Image(systemName: "bicycle")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(bike.accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(bike.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppTheme.navy)

                Text(bike.category)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)

                HStack(spacing: 8) {
                    Text("₱\(Int(bike.price))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppTheme.navy)
                    Spacer()
                    Text(stockLabel)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(stockStyle)
                        .clipShape(Capsule())
                }
            }

            Spacer()

            VStack(spacing: 8) {
                Button { onEdit() } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 28, height: 28)
                        .foregroundStyle(AppTheme.navy)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(role: .destructive) { onDelete() } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.white)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    var stockLabel: String {
        if bike.stock == 0 { return "Out" }
        if bike.stock <= 5 { return "Low" }
        return "In" 
    }
}

private struct OrderManagementCard: View {
    let order: Order
    let onStatusSelected: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(order.id)
                    .font(.system(size: 15, weight: .bold))
                Spacer()
                Text(order.status)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(statusColor(for: order.status))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(statusColor(for: order.status).opacity(0.12))
                    .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(order.customerName)
                    .font(.system(size: 13, weight: .semibold))
                Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
                HStack {
                    Text("Total")
                        .foregroundStyle(AppTheme.mutedText)
                    Spacer()
                    Text("₱\(Int(order.total))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppTheme.navy)
                }
            }

            Menu {
                ForEach(["Pending", "Processing", "Shipped", "Completed", "Cancelled"], id: \.self) { status in
                    Button(status) { onStatusSelected(status) }
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Update status")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.navy)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
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

private struct CustomerCard: View {
    let customer: User
    let orders: [Order]

    var totalSpent: Double {
        orders.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                ZStack {
                    Circle()
                        .fill(AppTheme.navy.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "person.fill")
                        .foregroundStyle(AppTheme.navy)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(customer.fullName)
                        .font(.system(size: 15, weight: .bold))
                    Text("\(orders.count) orders")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppTheme.mutedText)
                }

                Spacer()

                Text(formatCurrency(totalSpent))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppTheme.navy)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(customer.email)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
                Text(customer.phone.isEmpty ? "No phone number saved" : customer.phone)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.mutedText)
            }
        }
        .padding(14)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_PH")
        formatter.numberStyle = .currency
        formatter.currencyCode = "PHP"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "₱0"
    }
}

private struct RevenueDetailSheet: View {
    let orders: [Order]

    var body: some View {
        NavigationStack {
            List {
                ForEach(orders, id: \.id) { order in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(order.customerName)
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                            Text("₱\(Int(order.total))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(AppTheme.navy)
                        }
                        Text(order.id)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
                        Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppTheme.mutedText)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Revenue summary")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {}
                }
            }
        }
    }
}

private struct OrderDetailSheet: View {
    let order: Order
    let onStatusChange: (String) -> Void

    var statusColor: Color {
        switch order.status {
        case "Pending": return .orange
        case "Processing": return .blue
        case "Shipped": return .purple
        case "Completed": return .green
        case "Cancelled": return .red
        default: return .gray
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Order") {
                    LabeledContent("ID", value: order.id)
                    LabeledContent("Customer", value: order.customerName)
                    LabeledContent("Payment", value: order.paymentMethod)
                    LabeledContent("Address", value: order.address.isEmpty ? "Not provided" : order.address)
                }

                Section("Status") {
                    Picker("Current status", selection: Binding(
                        get: { order.status },
                        set: { onStatusChange($0) }
                    )) {
                        ForEach(["Pending", "Processing", "Shipped", "Completed", "Cancelled"], id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Items") {
                    ForEach(order.items, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("Qty: \(item.quantity)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                            Spacer()
                            Text("₱\(Int(item.unitPrice * Double(item.quantity)))")
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }

                Section("Totals") {
                    LabeledContent("Subtotal", value: "₱\(Int(order.subtotal))")
                    LabeledContent("Shipping", value: "₱\(Int(order.shipping))")
                    LabeledContent("Total", value: "₱\(Int(order.total))")
                }
            }
            .navigationTitle("Order details")
        }
    }
}

private struct ProductDetailSheet: View {
    let bike: Bike
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Overview") {
                    LabeledContent("Name", value: bike.name)
                    LabeledContent("Category", value: bike.category)
                    LabeledContent("Type", value: bike.type)
                    LabeledContent("Price", value: "₱\(Int(bike.price))")
                    LabeledContent("Stock", value: "\(bike.stock)")
                }

                Section("Description") {
                    Text(bike.description)
                }

                Section("Specifications") {
                    ForEach(Array(bike.specs.keys.sorted()), id: \.self) { key in
                        if let value = bike.specs[key] {
                            LabeledContent(key, value: value)
                        }
                    }
                }
            }
            .navigationTitle("Product details")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit") { onEdit() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", role: .destructive) { onDelete() }
                }
            }
        }
    }
}

private struct CustomerDetailSheet: View {
    let customer: User
    let orders: [Order]

    var totalSpent: Double {
        orders.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    LabeledContent("Name", value: customer.fullName)
                    LabeledContent("Email", value: customer.email)
                    LabeledContent("Phone", value: customer.phone.isEmpty ? "Not provided" : customer.phone)
                    LabeledContent("Orders", value: "\(orders.count)")
                    LabeledContent("Total spent", value: "₱\(Int(totalSpent))")
                }

                Section("Order history") {
                    ForEach(orders, id: \.id) { order in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(order.id)
                                .font(.system(size: 13, weight: .bold))
                            Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AppTheme.mutedText)
                            Text("\(order.status) • ₱\(Int(order.total))")
                                .font(.system(size: 12, weight: .medium))
                        }
                    }
                }
            }
            .navigationTitle("Customer details")
        }
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
