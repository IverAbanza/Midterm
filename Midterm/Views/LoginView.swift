import SwiftUI

struct LoginView: View {
    @ObservedObject var userController: UserController
    let onLoginSuccess: () -> Void
    let onCreateAccount: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var rememberMe = true
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome back")
                    .font(.system(size: 32, weight: .heavy))
                Text("Sign in to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                Text("Admin access: admin@bikestore.com / Admin123!")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .padding(14)

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing, 8)
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            HStack {
                Toggle("Remember me", isOn: $rememberMe)
                    .toggleStyle(.switch)
                Spacer()
                Button("Forgot password?") {
                    errorMessage = "Password recovery is not available in this demo mode."
                }
                .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
            }
            .font(.system(size: 13))

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.red)
            }

            PrimaryButton(title: "Login", icon: "arrow.right") {
                let result = userController.signIn(email: email, password: password)
                if result.0 {
                    errorMessage = ""
                    onLoginSuccess()
                } else {
                    errorMessage = result.1
                }
            }

            Button(action: onCreateAccount) {
                HStack(spacing: 6) {
                    Text("Don’t have an account?")
                        .foregroundStyle(.secondary)
                    Text("Sign Up")
                        .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                        .fontWeight(.bold)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

#Preview {
    LoginView(userController: UserController(), onLoginSuccess: {}, onCreateAccount: {})
}
