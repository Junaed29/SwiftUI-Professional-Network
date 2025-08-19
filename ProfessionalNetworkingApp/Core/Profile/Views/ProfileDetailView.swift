//
//  ProfileDetailView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

struct ProfileDetailView: View {
    // For “other user” profile we usually load by id
    let userID: String

    @Environment(\.appPalette) private var p
    @State private var vm = ProfileViewModel()


    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero
                HeaderHero(imageURL: vm.profile.imageURL)

                // Header card (name / age / location / menu)
                headerIdentity

                Divider().background(p.divider)

                // About
                section(title: "About") {
                    aboutSection
                }

                // Friends row
                if !vm.profile.friends.isEmpty {
                    section(title: "Friends") {
                        FriendsRow(friends: vm.profile.friends)
                    }
                }

                // Basics grid
                section(title: "Basic profile") {
                    BasicsGrid(
                        heightCM: vm.profile.heightCM,
                        weightKG: vm.profile.weightKG,
                        relationshipStatus: vm.profile.relationshipStatus,
                        ethnicity: vm.profile.ethnicity
                    )
                }

                // Interests
                if !vm.profile.interests.isEmpty {
                    section(title: "Interests") {
                        wrapChips(vm.profile.interests)
                    }
                }

                // Looking for
                if !vm.profile.lookingFor.isEmpty {
                    section(title: "Looking for") {
                        wrapChips(vm.profile.lookingFor)
                    }
                }

                Spacer(minLength: 88) // for bottom bar spacing
            }
            .background(LinearGradient(colors: [p.bg, p.bgAlt], startPoint: .top, endPoint: .bottom))
        }
        .overlay(alignment: .bottom) { actionBar }
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadOtherUserProfile(userID: userID) }
    }

    // MARK: - Subviews

    private var headerIdentity: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(vm.profile.fullName).font(.title3.weight(.semibold)).foregroundColor(p.secondary)
                        if let age = vm.profile.age {
                            Text("· \(age)").foregroundColor(p.secondary.opacity(0.9)).font(.headline)
                        }
                    }
                    HStack(spacing: 8) {
                        if vm.profile.isVerified {
                            Text("Verified")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(p.success)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        if let city = vm.profile.city, let country = vm.profile.country {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.and.ellipse")
                                Text("\(city), \(country)")
                            }
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(.ultraThinMaterial.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                }
                Spacer()
                Menu {
                    Button("Report", role: .destructive) {}
                    Button("Share Profile") {}
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
            .background(LinearGradient(colors: [Color.black.opacity(0.35), .clear], startPoint: .top, endPoint: .bottom))
        }
        .offset(y: -96) // pull over the hero
        .padding(.bottom, -96)
    }

    // MARK: - About Sections
    // Measurement to detect truncation beyond 3 lines
    @State private var fullBioHeight: CGFloat = 0
    @State private var limitedBioHeight: CGFloat = 0
    private let bioLineLimit: Int = 3
    @State private var showMoreAbout = false

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.sm) {
            Text(vm.profile.bio)
                .styled(.body, color: p.textSecondary)
                .lineLimit(showMoreAbout ? nil : bioLineLimit)
                .background(
                    // Measure limited height (3 lines) using an invisible twin
                    Text(vm.profile.bio)
                        .styled(.body, color: p.textSecondary)
                        .lineLimit(bioLineLimit)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: LimitedTextHeightKey.self, value: geo.size.height)
                        })
                        .hidden()
                )
                .overlay(
                    // Measure full height (no limit) using another invisible twin
                    Text(vm.profile.bio)
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

            if fullBioHeight > (limitedBioHeight + 1) { // show toggle only when truncated
                Button(action: { withAnimation(.easeInOut) { showMoreAbout.toggle() } }) {
                    Text(showMoreAbout ? "Show less" : "Show more")
                        .styled(.caption, color: p.primary)
                }
            }
        }
    }

    private func wrapChips(_ items: [String]) -> some View {
        FlexibleChips(items: items)
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline).foregroundColor(p.textPrimary)
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(p.bg.opacity(0.001)) // list-friendly tap area
    }

    private var actionBar: some View {
        HStack(spacing: 16) {
            Button {
                // dislike / pass
            } label: {
                Image(systemName: "heart.slash")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(p.alert)
                    .frame(width: 54, height: 54)
                    .background(p.card)
                    .clipShape(Circle())
                    .shadow(radius: 4, y: 2)
            }

            Button {
                // like
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(p.primary)
                    .clipShape(Circle())
                    .shadow(radius: 6, y: 3)
            }

            Button {
                // message
            } label: {
                Image(systemName: "ellipsis.message.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 54, height: 54)
                    .background(p.info)
                    .clipShape(Circle())
                    .shadow(radius: 4, y: 2)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Layout helper to wrap chips across lines
private struct FlexibleChips: View {
    @Environment(\.appPalette) private var p
    let items: [String]

    var body: some View {
        FlowLayout(spacing: AppTheme.Space.sm, lineSpacing: AppTheme.Space.sm) {
            ForEach(items, id: \.self) { title in
                ChipView(text: title,outline: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Header hero image with gradient
private struct HeaderHero: View {
    @Environment(\.appPalette) private var p
    let imageURL: URL?

    var body: some View {
        ZStack(alignment: .bottom) {
            ImageLoader(
                url: imageURL,
                contentMode: .fill,
                cornerRadius: 12
            )
            LinearGradient(
                colors: [Color.black.opacity(0.55), Color.black.opacity(0.0)],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 180)
        }
        .frame(height: 360)
        .clipped()
    }
}

// MARK: - Preference keys for measuring text heights
private struct FullTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}
private struct LimitedTextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}

// MARK: - Friends avatars row
private struct FriendsRow: View {
    @Environment(\.appPalette) private var p
    let friends: [Friend]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(friends) { f in
                    ImageLoader(
                        url: f.avatarURL,
                        contentMode: .fill,
                    )
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(p.divider))
                    .overlay(alignment: .bottomTrailing) {
                        Circle().fill(.white).frame(width: 10, height: 10)
                            .overlay(Circle().fill(p.success).frame(width: 8, height: 8))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Basics grid
private struct BasicsGrid: View {
    @Environment(\.appPalette) private var p
    let heightCM: Int?
    let weightKG: Int?
    let relationshipStatus: String?
    let ethnicity: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            InfoRow(label: "Height", value: heightCM.map { "\($0) cm" })
            InfoRow(label: "Weight", value: weightKG.map { "\($0) kg" })
            InfoRow(label: "Relationship status", value: relationshipStatus)
            InfoRow(label: "Ethnicity", value: ethnicity)
        }
    }

    private struct InfoRow: View {
        @Environment(\.appPalette) private var p
        let label: String
        let value: String?
        var body: some View {
            HStack {
                Text(label).foregroundColor(p.textSecondary)
                Spacer()
                Text(value ?? "—").foregroundColor(p.textPrimary)
            }
            .font(.subheadline)
            .padding(.vertical, 6)
            .overlay(Divider().background(p.divider), alignment: .bottom)
        }
    }
}


#Preview {
    ProfileDetailView(userID: "1")
}
