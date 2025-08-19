// ProfileCardView.swift

import SwiftUI

struct ProfileCardView: View {
    @Environment(\.appPalette) private var p
    let card: UserCard

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(p.card)
                .overlay(photo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: p.textPrimary.opacity(0.12), radius: 8, y: 6)

            footer
                .padding(AppTheme.Space.lg)
        }
        .frame(maxWidth: .infinity, minHeight: 420, maxHeight: 520)
    }

    private var photo: some View {
        Group {
            if let url = card.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack { p.bgAlt; ProgressView().tint(p.primary) }
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        ZStack { p.bgAlt; Image(systemName: "person.fill").font(.largeTitle).foregroundColor(p.textSecondary) }
                    @unknown default:
                        Color.clear
                    }
                }
            } else {
                ZStack { p.bgAlt; Image(systemName: "person.fill").font(.largeTitle).foregroundColor(p.textSecondary) }
            }
        }
        .overlay(alignment: .topTrailing) { flameBadge.padding(AppTheme.Space.sm) }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            HStack(spacing: AppTheme.Space.sm) {
                Text(card.name).font(.title3.weight(.semibold)).foregroundColor(p.secondary)
                Text("\(card.age)").font(.headline).foregroundColor(p.secondary)
            }
            HStack(spacing: AppTheme.Space.sm) {
                tagChip(card.tag)
                Text(card.location).styled(.caption, color: p.secondary.opacity(0.9))
                Spacer()
            }
        }
        .padding(AppTheme.Space.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.95)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, AppTheme.Space.lg)
        .padding(.bottom, AppTheme.Space.sm)
    }

    private func tagChip(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(p.secondary)
            .padding(.horizontal, AppTheme.Space.sm)
            .padding(.vertical, AppTheme.Space.xs)
            .background(p.alert.opacity(0.9))
            .clipShape(Capsule())
    }

    private var flameBadge: some View {
        ZStack {
            Circle().fill(p.secondary).frame(width: 44, height: 44)
            Image(systemName: "flame.fill").foregroundColor(p.alert)
        }
        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
    }
}

#Preview {
    ProfileCardView(card: UserCard(
        name: "Herman West",
        age: 20,
        location: "Seattle, USA",
        tag: "Versatile",
        imageURL: nil,
        photos: [],
        bio: "Sample bio",
        heightCM: 172,
        weightKG: 75,
        relationshipStatus: "Single",
        ethnicity: "Asian",
        interests: ["Music"],
        lookingFor: ["Friend"],
        friends: []
    ))
        .appTheme()
}
