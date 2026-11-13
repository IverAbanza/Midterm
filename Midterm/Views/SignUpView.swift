import SwiftUI

struct SignUpView: View {
    @ObservedObject var userController: UserController
    let onBack: () -> Void
    let onSignedUp: () -> Void

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(.primary)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .heavy))
                Text("Join the BikeStore community")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 14) {
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

                SecureField("Password", text: $password)
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                SecureField("Confirm password", text: $confirmPassword)
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Toggle("I agree to the terms and conditions", isOn: $agreeToTerms)
                .font(.system(size: 13))

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.red)
            }

            PrimaryButton(title: "Create Account", icon: "person.badge.plus") {
                if !agreeToTerms {
                    errorMessage = "You must accept the terms and conditions."
                    return
                }

                let result = userController.signUp(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
                if result.0 {
                    errorMessage = ""
                    onSignedUp()
                } else {
                    errorMessage = result.1
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
}

#Preview {
    SignUpView(userController: UserController(), onBack: {}, onSignedUp: {})
}
