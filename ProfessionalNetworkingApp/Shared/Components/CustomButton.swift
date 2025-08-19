// CustomButton.swift

import SwiftUI

struct CustomButton: View {
    let title: String
    var style: ButtonStyleType = .primary
    var action: () -> Void

    enum ButtonStyleType { case primary, secondary }

    var body: some View {
        Button(action: action) {
            Text(title).frame(maxWidth: .infinity)
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    CustomButton(title: "Continue", action: {})
}
