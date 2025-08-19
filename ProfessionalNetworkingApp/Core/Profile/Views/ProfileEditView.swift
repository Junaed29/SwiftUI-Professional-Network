// ProfileEditView.swift

import SwiftUI

struct ProfileEditView: View {
    @Binding var profile: UserProfile

    var body: some View {
        Form {
            TextField("Full Name", text: $profile.fullName)
            TextField("Headline", text: $profile.headline)
            TextField("Bio", text: $profile.bio)
        }
        .navigationTitle("Edit Profile")
    }
}

#Preview {
    StatefulPreviewWrapper(UserProfile()) { ProfileEditView(profile: $0) }
}
