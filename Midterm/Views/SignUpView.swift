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
        VStack(spacing: 22) {
            HStack {
                Button(action: onBackToLogin) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Create account")
                    .font(.system(size: 32, weight: .heavy))
                Text("Join BikeStore and start shopping")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextField("Full name", text: $fullName)
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

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

                HStack {
                    Group {
                        if isConfirmPasswordVisible {
                            TextField("Confirm password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm password", text: $confirmPassword)
                        }
                    }
                    .padding(14)

                    Button {
                        isConfirmPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing, 8)
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
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
                        .foregroundStyle(.secondary)
                    Text("Login")
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
    SignUpView(
        userController: UserController(),
        onBackToLogin: {},
        onSignUpSuccess: {}
    )
}
