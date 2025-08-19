// Shared/Components/ImageLoader.swift
import SwiftUI

struct ImageLoader: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 0
    var showsProgress: Bool = true

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    case .failure:
                        fallback
                    @unknown default:
                        fallback
                    }
                }
            } else {
                fallback
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    @ViewBuilder private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.12)
            if showsProgress { ProgressView() }
        }
    }

    private var fallback: some View {
        ZStack {
            Color.gray.opacity(0.15)
            Image(systemName: "photo")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.gray.opacity(0.7))
        }
    }
}