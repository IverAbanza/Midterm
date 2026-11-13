import SwiftUI

struct EditProfileView: View {
    @ObservedObject var userController: UserController
    let onSave: () -> Void

    @State private var fullName: String
    @State private var email: String
    @State private var phone: String
    @State private var errorMessage = ""

    init(userController: UserController, onSave: @escaping () -> Void) {
        self.userController = userController
        self.onSave = onSave
        self._fullName = State(initialValue: userController.currentUser?.fullName ?? "")
        self._email = State(initialValue: userController.currentUser?.email ?? "")
        self._phone = State(initialValue: userController.currentUser?.phone ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.07, green: 0.11, blue: 0.21).opacity(0.12))
                        .frame(width: 92, height: 92)
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color(red: 0.07, green: 0.11, blue: 0.21))
                }

                VStack(spacing: 12) {
                    TextField("Full name", text: $fullName)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    TextField("Phone number", text: $phone)
                        .keyboardType(.phonePad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }

                PrimaryButton(title: "Save Changes", icon: "checkmark") {
                    let result = userController.saveProfile(fullName: fullName, email: email, phone: phone)
                    if result.0 {
                        errorMessage = ""
                        onSave()
                    } else {
                        errorMessage = result.1
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Edit Profile")
    }
}

#Preview {
    EditProfileView(userController: UserController(), onSave: {})
}
