import Foundation

// MARK: - Supabase configuration
// Add the Supabase Swift package in Xcode and replace these values with your project details.
enum SupabaseConfig {
    static let url = URL(string: "https://YOUR_PROJECT_REF.supabase.co")!
    static let anonKey = "YOUR_ANON_KEY"
    static let adminRole = "admin"
    static let customerRole = "customer"
}
