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
        ZStack {
            LinearGradient(
                colors: [AppTheme.lightBlue, Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("BikeStore")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppTheme.navy)
                        .tracking(1.2)

                    Text("Welcome back")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundStyle(.primary)

                    Text("Sign in to continue your ride")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(AppTheme.mutedText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)

                VStack(spacing: 16) {
                    Group {
                        TextField("Email address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(16)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.primary.opacity(0.04), lineWidth: 1)
                            )

                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                } else {
                                    SecureField("Password", text: $password)
                                }
                            }
                            .padding(16)

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(AppTheme.mutedText)
                                    .padding(.trailing, 8)
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.primary.opacity(0.04), lineWidth: 1)
                        )
                    }
                }

                HStack {
                    Toggle("Remember me", isOn: $rememberMe)
                        .toggleStyle(.switch)
                    Spacer()
                    Button("Forgot password?") {
                        errorMessage = "Password recovery is not available in this version."
                    }
                    .foregroundStyle(AppTheme.navy)
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
                            .foregroundStyle(AppTheme.mutedText)
                        Text("Sign Up")
                            .foregroundStyle(AppTheme.navy)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
    }
}

#Preview {
    LoginView(userController: UserController(), onLoginSuccess: {}, onCreateAccount: {})
}
