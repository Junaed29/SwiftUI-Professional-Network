// UserDetailView.swift

import SwiftUI

struct UserDetailView: View {
    @Environment(\.appPalette) private var p
    let card: UserCard
    @State private var showMoreAbout = false

    var body: some View {
        ThemedScreen(usePadding: false, background: .solid) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Space.lg) {
                    hero
                    header
                    Divider().overlay(p.divider)
                    aboutSection
                    friendsSection
                    basicProfileSection
                    interestsSection
                    lookingForSection
                    Spacer(minLength: AppTheme.Space.xl)
                }
                .padding(.horizontal, AppTheme.Space.lg)
                .padding(.top, AppTheme.Space.lg)
                .padding(.bottom, 96) // space for bottom bar
            }
            .safeAreaInset(edge: .bottom) { bottomBar }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Top
    private var hero: some View {
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
        .frame(height: 280)
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            HStack(spacing: AppTheme.Space.sm) {
                Text(card.name)
                    .font(.title.weight(.semibold))
                    .foregroundColor(p.secondary)
                Text("\(card.age)")
                    .font(.headline)
                    .foregroundColor(p.secondary)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "ellipsis").font(.headline).foregroundColor(p.secondary)
                }
            }
            HStack(spacing: AppTheme.Space.sm) {
                tagChip(card.tag)
                Text(card.location).styled(.body, color: p.textSecondary)
            }
        }
    }

    // MARK: - Sections
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("About")
            Text(card.bio)
                .styled(.body, color: p.textSecondary)
                .lineLimit(showMoreAbout ? nil : 3)
            Button(action: { withAnimation(.easeInOut) { showMoreAbout.toggle() } }) {
                Text(showMoreAbout ? "Show less" : "Show more")
                    .styled(.caption, color: p.primary)
            }
        }
    }

    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("Friends")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Space.md) {
                    ForEach(Array(card.friends.enumerated()), id: \.offset) { _, url in
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty: Circle().fill(p.bgAlt).frame(width: 44, height: 44)
                            case .success(let image): image.resizable().scaledToFill().frame(width: 44, height: 44).clipShape(Circle())
                            case .failure: Circle().fill(p.bgAlt).overlay(Image(systemName: "person.fill").foregroundColor(p.textSecondary)).frame(width: 44, height: 44)
                            @unknown default: EmptyView()
                            }
                        }
                    }
                }
            }
        }
    }

    private var basicProfileSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("Basic profile")
            VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
                if let h = card.heightCM { infoRow("Height", value: "\(h)cm") }
                if let w = card.weightKG { infoRow("Weight", value: "\(w)kg") }
                if let rs = card.relationshipStatus { infoRow("Relationship status", value: rs) }
                if let eth = card.ethnicity { infoRow("Ethnicity", value: eth) }
            }
        }
    }

    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("Interesting")
            wrapChips(card.interests)
        }
    }

    private var lookingForSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("Looking for")
            wrapChips(card.lookingFor)
        }
    }

    // MARK: - Bottom bar
    private var bottomBar: some View {
        HStack(spacing: AppTheme.Space.lg) {
            circleAction(system: "xmark", bg: p.secondary, fg: p.alert)
            circleAction(system: "heart.fill", bg: p.primary, fg: p.secondary)
            circleAction(system: "bubble.left.fill", bg: p.secondary, fg: p.primary)
        }
        .padding(.vertical, AppTheme.Space.md)
        .background(p.bg.opacity(0.9))
    }

    // MARK: - Helpers
    private func sectionTitle(_ text: String) -> some View {
        Text(text).styled(.title3)
    }

    private func infoRow(_ key: String, value: String) -> some View {
        HStack {
            Text("\(key) :").styled(.body, color: p.textSecondary)
            Text(value).styled(.body)
            Spacer()
        }
    }

    private func wrapChips(_ items: [String]) -> some View {
        FlexibleChips(items: items)
    }

    private func tagChip(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(p.secondary)
            .padding(.horizontal, AppTheme.Space.sm)
            .padding(.vertical, AppTheme.Space.xs)
            .background(p.alert)
            .clipShape(Capsule())
    }

    private func circleAction(system: String, bg: Color, fg: Color) -> some View {
        Image(systemName: system)
            .font(.title2.weight(.bold))
            .foregroundColor(fg)
            .frame(width: 56, height: 56)
            .background(bg)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
            .frame(maxWidth: .infinity)
    }
}

// Layout helper to wrap chips across lines
private struct FlexibleChips: View {
    @Environment(\.appPalette) private var p
    let items: [String]

    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                chip(item)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > UIScreen.main.bounds.width - 48) {
                            width = 0
                            height -= d.height + AppTheme.Space.sm
                        }
                        let result = width
                        if item == items.last { width = 0 } else { width -= d.width + AppTheme.Space.sm }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if item == items.last { height = 0 }
                        return result
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func chip(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundColor(p.textPrimary)
            .padding(.horizontal, AppTheme.Space.md)
            .padding(.vertical, AppTheme.Space.xs)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(p.divider, lineWidth: 1)
            )
    }
}

#Preview {
    UserDetailView(card: UserCard(
        name: "Ava",
        age: 23,
        location: "Engineer City",
        tag: "Engineer",
        imageURL: nil,
        photos: [],
        bio: "Curious builder who enjoys books and brunch.",
        heightCM: 168,
        weightKG: 58,
        relationshipStatus: "Single",
        ethnicity: "Asian",
        interests: ["Reading", "Music", "Hiking"],
        lookingFor: ["Friend", "Dating"],
        friends: []
    ))
    .appTheme()
}
