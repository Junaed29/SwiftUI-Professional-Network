// ProfileImageView.swift

import SwiftUI

struct ProfileImageView: View {
    let url: URL?

    var body: some View {
        ZStack {
            if let _ = url {
                // In real app, load async image
                Circle().fill(Color.blue.opacity(0.2)).overlay(Image(systemName: "person.fill")).foregroundColor(.blue)
            } else {
                Circle().fill(Color.gray.opacity(0.2)).overlay(Image(systemName: "person")).foregroundColor(.gray)
            }
        }
    }
}

#Preview { ProfileImageView(url: nil) }
