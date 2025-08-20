// UserDetailView.swift
//
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI

struct UserDetailView: View {
    let profile: UserCard
    @Environment(\.appPalette) private var p
    @State private var showMoreAbout = false
    @State private var fullBioHeight: CGFloat = 0
    @State private var limitedBioHeight: CGFloat = 0
    private let bioLineLimit = 3

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Space.lg) {
                    hero
                    header
                    Divider().overlay(p.divider)
                    aboutSection
                    if !profile.skills.isEmpty { sectionTitle("Skills"); chips(profile.skills) }
                    if !profile.interests.isEmpty { sectionTitle("Interests"); chips(profile.interests) }
                    if !profile.openTo.isEmpty { sectionTitle("Open to"); chips(profile.openTo.map { $0.rawValue.capitalized }) }
                    Spacer(minLength: AppTheme.Space.xl)
                }
                .padding(.horizontal, AppTheme.Space.lg)
                .padding(.top, AppTheme.Space.lg)
                .padding(.bottom, AppTheme.Space.lg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections
    private var hero: some View {
        ZStack(alignment: .bottom) {
            ImageLoader(url: profile.avatarURL, contentMode: .fill, cornerRadius: 12)
            LinearGradient(colors: [Color.black.opacity(0.5), .clear], startPoint: .bottom, endPoint: .top)
                .frame(height: 120)
        }
        .frame(height: 320)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            Text(profile.fullName)
                .font(.title2.weight(.semibold))
                .foregroundColor(p.secondary)
            if !profile.headline.isEmpty {
                Text(profile.headline)
                    .styled(.body, color: p.textSecondary)
            }
            HStack(spacing: AppTheme.Space.sm) {
                if let city = profile.city, let country = profile.country {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(city), \(country)")
                    }
                    .styled(.caption, color: p.textSecondary)
                }
                if profile.isVerified {
                    ChipView(text: "Verified", background: p.success.opacity(0.9), textColor: .white)
                }
            }
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            sectionTitle("About")
            Text(profile.bio)
                .styled(.body, color: p.textSecondary)
                .lineLimit(showMoreAbout ? nil : bioLineLimit)
                .background(
                    Text(profile.bio)
                        .styled(.body, color: p.textSecondary)
                        .lineLimit(bioLineLimit)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: LimitedTextHeightKey.self, value: geo.size.height)
                        })
                        .hidden()
                )
                .overlay(
                    Text(profile.bio)
                        .styled(.body, color: p.textSecondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: FullTextHeightKey.self, value: geo.size.height)
                        })
                        .hidden()
                )
                .onPreferenceChange(LimitedTextHeightKey.self) { limitedBioHeight = $0 }
                .onPreferenceChange(FullTextHeightKey.self) { fullBioHeight = $0 }

            if fullBioHeight > (limitedBioHeight + 1) {
                Button(action: { withAnimation(.easeInOut) { showMoreAbout.toggle() } }) {
                    Text(showMoreAbout ? "Show less" : "Show more").styled(.caption, color: p.primary)
                }
            }
        }
    }

    @ViewBuilder private func chips(_ items: [String]) -> some View {
        FlowLayout(spacing: AppTheme.Space.sm, lineSpacing: AppTheme.Space.sm) {
            ForEach(items, id: \.self) { title in
                ChipView(text: title, outline: true)
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View { Text(text).styled(.title3) }
}

private struct FullTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}
private struct LimitedTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}
#Preview {
    UserDetailView(profile: MockProfiles.sample[0])
    .appTheme()
}
