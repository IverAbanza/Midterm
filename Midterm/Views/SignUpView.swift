import SwiftUI

struct SignUpView: View {
    @ObservedObject var userController: UserController
    let onBackToLogin: () -> Void
    let onSignUpSuccess: () -> Void

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.lightBlue, Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                HStack {
                    Button(action: onBackToLogin) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(AppTheme.navy)
                            .frame(width: 38, height: 38)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Circle())
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Create account")
                        .font(.system(size: 34, weight: .heavy))
                    Text("Join BikeStore and start shopping")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(AppTheme.mutedText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    TextField("Full name", text: $fullName)
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.primary.opacity(0.04), lineWidth: 1)
                        )

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

                    HStack {
                        Group {
                            if isConfirmPasswordVisible {
                                TextField("Confirm password", text: $confirmPassword)
                            } else {
                                SecureField("Confirm password", text: $confirmPassword)
                            }
                        }
                        .padding(16)

                        Button {
                            isConfirmPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
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

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }

                PrimaryButton(title: "Create Account", icon: "checkmark") {
                    let result = userController.signUp(
                        fullName: fullName,
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword
                    )

                    if result.0 {
                        errorMessage = ""
                        onSignUpSuccess()
                    } else {
                        errorMessage = result.1
                    }
                }

                Button(action: onBackToLogin) {
                    HStack(spacing: 6) {
                        Text("Already have an account?")
                            .foregroundStyle(AppTheme.mutedText)
                        Text("Login")
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
    SignUpView(
        userController: UserController(),
        onBackToLogin: {},
        onSignUpSuccess: {}
    )
}
