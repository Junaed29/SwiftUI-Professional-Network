//
//  ProfileDetailView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

struct ProfileDetailView: View {
    let userID: String

    @Environment(\.appPalette) private var p
    @State private var vm = ProfileViewModel()

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            Group {
                if vm.isLoading {
                    ThemedLoadingView(message: "Loading profile…")
                } else if let error = vm.errorMessage {
                    VStack(spacing: AppTheme.Space.lg) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 34))
                            .foregroundColor(p.alert)
                        Text("Failed to load profile")
                            .styled(.headline)
                        Text(error)
                            .styled(.body, color: p.textSecondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await vm.loadOtherUserProfile(userID: userID) }
                        }
                        .buttonStyle(OutlineButtonStyle())
                        .frame(maxWidth: 200)
                    }
                    .padding()
                } else {
                    content
                }
            }
        }
        .overlay(alignment: .bottom) { if !vm.isLoading && vm.errorMessage == nil { actionBar } }
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadOtherUserProfile(userID: userID) }
    }

    // MARK: - Content
    private var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero
                HeaderHero(imageURL: vm.profile.avatarURL)

                // Header card (name / headline / location / menu)
                headerIdentity

                Divider().background(p.divider)

                // About
                section(title: "About") { aboutSection }

                // Connections row
                if !vm.profile.connections.isEmpty {
                    section(title: "Connections") {
                        ConnectionsRow(connections: vm.profile.connections)
                    }
                }

                // Career basics
                section(title: "Career") {
                    CareerGrid(
                        position: vm.profile.currentPosition,
                        company: vm.profile.company,
                        industry: vm.profile.industry,
                        experienceYears: vm.profile.experienceYears
                    )
                }

                // Skills
                if !vm.profile.skills.isEmpty {
                    section(title: "Skills") { wrapChips(vm.profile.skills) }
                }

                // Interests
                if !vm.profile.interests.isEmpty {
                    section(title: "Interests") { wrapChips(vm.profile.interests) }
                }

                // Open To
                if !vm.profile.openTo.isEmpty {
                    section(title: "Open to") { wrapChips(vm.profile.openTo.map { $0.rawValue.capitalized }) }
                }

                // Education
                if !vm.profile.education.isEmpty {
                    section(title: "Education") { educationList }
                }

                Spacer(minLength: 88) // for bottom bar spacing
            }
        }
    }

    // MARK: - Subviews

    private var headerIdentity: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.profile.fullName)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(p.secondary)
                    if !vm.profile.headline.isEmpty {
                        Text(vm.profile.headline)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(.ultraThinMaterial.opacity(0.2))
                            .cornerRadius(6)
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

    // About measurement state
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
                Image(systemName: "person.badge.minus")
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
                Image(systemName: "person.crop.circle.badge.plus")
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
                Image(systemName: "paperplane.fill")
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

// MARK: - Connections avatars row
private struct ConnectionsRow: View {
    @Environment(\.appPalette) private var p
    let connections: [Connection]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(connections) { c in
                    ImageLoader(url: c.avatarURL, contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(p.divider))
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Career grid
private struct CareerGrid: View {
    @Environment(\.appPalette) private var p
    let position: String?
    let company: String?
    let industry: String?
    let experienceYears: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            InfoRow(label: "Position", value: position)
            InfoRow(label: "Company", value: company)
            InfoRow(label: "Industry", value: industry)
            InfoRow(label: "Experience", value: experienceYears.map { "\($0) years" })
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

// MARK: - Education list
private extension ProfileDetailView {
    var educationList: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(vm.profile.education) { e in
                VStack(alignment: .leading, spacing: 2) {
                    Text(e.institution).styled(.body)
                    HStack(spacing: 6) {
                        if let degree = e.degree { Text(degree).styled(.caption, color: p.textSecondary) }
                        Spacer()
                        if let start = e.startYear, let end = e.endYear { Text("· \(start)-\(end)").styled(.caption, color: p.textSecondary) }
                    }
                }
                .padding(.vertical, 4)
                .overlay(Divider().background(p.divider), alignment: .bottom)
            }
        }
    }
}


#Preview {
    ProfileDetailView(userID: "1")
}
