import Foundation
import Combine

final class UserController: ObservableObject {
    static let adminEmail = User.adminEmail
    static let adminRole = User.adminRole
    static let customerRole = User.customerRole

    @Published var currentUser: User?
    @Published var isLoggedIn: Bool
    @Published var onboardingCompleted: Bool

    var isAdmin: Bool {
        currentUser?.isAdmin == true
    }

    private let legacyUserKey = "bikeStore.user"
    private let usersKey = "bikeStore.users"
    private let favoritesKey = "bikeStore.favorites"
    private let loginKey = "bikeStore.loggedin"
    private let activeUserEmailKey = "bikeStore.activeUserEmail"
    private let onboardingKey = "bikeStore.onboarding"

    init() {
        self.currentUser = UserController.loadSavedUser()
        self.isLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
        self.onboardingCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
    }

    static func normalizedEmail(_ email: String) -> String {
        email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func normalizedRole(_ value: String?) -> String {
        (value ?? customerRole).lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func loadSavedUsers() -> [User] {
        if let data = UserDefaults.standard.data(forKey: "bikeStore.users"),
           let decoded = try? JSONDecoder().decode([User].self, from: data),
           !decoded.isEmpty {
            return decoded
        }

        if let legacyData = UserDefaults.standard.data(forKey: "bikeStore.user"),
           let decoded = try? JSONDecoder().decode(User.self, from: legacyData) {
            return [decoded]
        }

        return []
    }

    static func loadSavedUser() -> User? {
        let activeEmail = UserDefaults.standard.string(forKey: "bikeStore.activeUserEmail")?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let users = loadSavedUsers()

        if let activeEmail, let match = users.first(where: { Self.normalizedEmail($0.email) == activeEmail }) {
            return match
        }

        return users.first
    }

    static func isAuthorizedAdminUser(_ user: User?) -> Bool {
        guard let user else { return false }
        let normalizedEmail = normalizedEmail(user.email)
        let normalizedRole = normalizedRole(user.role)
        return normalizedEmail == adminEmail && normalizedRole == adminRole
    }

    func signUp(fullName: String, email: String, password: String, confirmPassword: String) -> (Bool, String) {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return (false, "Please fill in all fields.")
        }

        let normalizedEmail = Self.normalizedEmail(email)

        if !normalizedEmail.contains("@") || !normalizedEmail.contains(".") {
            return (false, "Enter a valid email address.")
        }

        if normalizedEmail == Self.adminEmail {
            return (false, "The admin account is reserved for the authorized BikeStore administrator.")
        }

        if Self.loadSavedUsers().contains(where: { Self.normalizedEmail($0.email) == normalizedEmail }) {
            return (false, "An account with this email already exists.")
        }

        if password.count < 6 {
            return (false, "Password must be at least 6 characters.")
        }

        if password != confirmPassword {
            return (false, "Passwords do not match.")
        }

        let user = User(
            id: UUID(),
            fullName: fullName,
            email: normalizedEmail,
            phone: "",
            address: "",
            password: password,
            role: Self.customerRole
        )

        currentUser = user
        isLoggedIn = true
        saveUser(user)
        UserDefaults.standard.set(normalizedEmail, forKey: activeUserEmailKey)
        UserDefaults.standard.set(true, forKey: loginKey)

        return (true, "Account created successfully.")
    }

    func signIn(email: String, password: String) -> (Bool, String) {
        if email.isEmpty || password.isEmpty {
            return (false, "Email and password are required.")
        }

        let normalizedEmail = Self.normalizedEmail(email)
        let matchingUsers = Self.loadSavedUsers().filter { Self.normalizedEmail($0.email) == normalizedEmail }

        guard let savedUser = matchingUsers.first else {
            if normalizedEmail == Self.adminEmail {
                return (false, "No authorized admin account is configured for this app. Provision the admin account securely through the existing authentication system.")
            }
            return (false, "Invalid email or password.")
        }

        guard savedUser.password == password else {
            return (false, "Invalid email or password.")
        }

        if normalizedEmail == Self.adminEmail {
            if savedUser.isAdmin {
                currentUser = savedUser
                isLoggedIn = true
                UserDefaults.standard.set(normalizedEmail, forKey: activeUserEmailKey)
                UserDefaults.standard.set(true, forKey: loginKey)
                return (true, "Admin login successful.")
            }
            return (false, "This account is not authorized as the BikeStore administrator.")
        }

        if Self.normalizedRole(savedUser.role) == Self.customerRole {
            currentUser = savedUser
            isLoggedIn = true
            UserDefaults.standard.set(normalizedEmail, forKey: activeUserEmailKey)
            UserDefaults.standard.set(true, forKey: loginKey)
            return (true, "Login successful.")
        }

        return (false, "This account is not authorized for customer access.")
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: loginKey)
        UserDefaults.standard.removeObject(forKey: activeUserEmailKey)
    }

    func saveProfile(fullName: String, email: String, phone: String, address: String = "") -> (Bool, String) {
        guard let user = currentUser else { return (false, "No user available.") }

        if fullName.isEmpty || email.isEmpty {
            return (false, "Full name and email are required.")
        }

        let finalAddress = address.isEmpty ? user.address : address
        let updated = User(id: user.id, fullName: fullName, email: email, phone: phone, address: finalAddress, password: user.password, role: user.role)
        currentUser = updated
        saveUser(updated)
        return (true, "Profile updated successfully.")
    }

    func completeOnboarding() {
        onboardingCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    func registeredCustomers() -> [User] {
        var users: [User] = []

        for user in Self.loadSavedUsers() {
            if !user.isAdmin {
                if !users.contains(where: { $0.id == user.id }) {
                    users.append(user)
                }
            }
        }

        if let current = currentUser, !current.isAdmin, !users.contains(where: { $0.id == current.id }) {
            users.append(current)
        }

        return users
    }

    func favoriteBikeIDs() -> [String] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
    }

    func isFavorite(_ bikeId: UUID) -> Bool {
        favoriteBikeIDs().contains(bikeId.uuidString)
    }

    func toggleFavorite(_ bikeId: UUID) -> Bool {
        var ids = favoriteBikeIDs()
        let key = bikeId.uuidString
        if let index = ids.firstIndex(of: key) {
            ids.remove(at: index)
        } else {
            ids.append(key)
        }
        UserDefaults.standard.set(ids, forKey: favoritesKey)
        return ids.contains(key)
    }

    func favoriteBikes(in bikes: [Bike]) -> [Bike] {
        let ids = Set(favoriteBikeIDs())
        return bikes.filter { ids.contains($0.id.uuidString) }
    }

    private func saveUser(_ user: User) {
        var users = Self.loadSavedUsers()

        if let index = users.firstIndex(where: { $0.id == user.id || Self.normalizedEmail($0.email) == Self.normalizedEmail(user.email) }) {
            users[index] = user
        } else {
            users.append(user)
        }

        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }

        if let legacyData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(legacyData, forKey: legacyUserKey)
        }
    }
}
