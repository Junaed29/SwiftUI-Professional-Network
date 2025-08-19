// CustomTextField.swift

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            TextField(title, text: $text)
                .keyboardType(keyboard)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
}

#Preview {
    StatefulPreviewWrapper("") { CustomTextField(title: "Email", text: $0, keyboard: .emailAddress) }
}
