import Foundation
import Combine

final class UserController: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool
    @Published var onboardingCompleted: Bool

    private let userKey = "bikeStore.user"
    private let loginKey = "bikeStore.loggedin"
    private let onboardingKey = "bikeStore.onboarding"

    init() {
        self.currentUser = UserController.loadSavedUser()
        self.isLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
        self.onboardingCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
    }

    static func loadSavedUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "bikeStore.user"),
              let decoded = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return decoded
    }

    func signUp(fullName: String, email: String, password: String, confirmPassword: String) -> (Bool, String) {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return (false, "Please fill in all fields.")
        }

        if !email.contains("@") || !email.contains(".") {
            return (false, "Enter a valid email address.")
        }

        if password.count < 6 {
            return (false, "Password must be at least 6 characters.")
        }

        if password != confirmPassword {
            return (false, "Passwords do not match.")
        }

        let user = User(id: UUID(), fullName: fullName, email: email, phone: "", password: password)
        currentUser = user
        isLoggedIn = true
        saveUser(user)
        UserDefaults.standard.set(true, forKey: loginKey)
        return (true, "Account created successfully.")
    }

    func signIn(email: String, password: String) -> (Bool, String) {
        if email.isEmpty || password.isEmpty {
            return (false, "Email and password are required.")
        }

        if let savedUser = Self.loadSavedUser(), savedUser.email.lowercased() == email.lowercased() && savedUser.password == password {
            currentUser = savedUser
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: loginKey)
            return (true, "Login successful.")
        }

        return (false, "Invalid email or password.")
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: loginKey)
    }

    func saveProfile(fullName: String, email: String, phone: String) -> (Bool, String) {
        guard let user = currentUser else { return (false, "No user available.") }

        if fullName.isEmpty || email.isEmpty {
            return (false, "Full name and email are required.")
        }

        let updated = User(id: user.id, fullName: fullName, email: email, phone: phone, password: user.password)
        currentUser = updated
        saveUser(updated)
        return (true, "Profile updated successfully.")
    }

    func completeOnboarding() {
        onboardingCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    private func saveUser(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(data, forKey: userKey)
    }
}
