// UserDetailView.swift
//
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI

struct UserDetailView: View {
    let profile: UserCard
    @Environment(\.appPalette) private var p


    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero
                    HeaderHero(imageURL: profile.avatarURL)

                    // Header card (name / headline / location / menu)
                    headerIdentity

                    Divider().background(p.divider)

                    // About
                    section(title: "About") { ExpandableText(profile.bio) }

                    // Connections row
                    if !profile.connections.isEmpty {
                        section(title: "Connections") {
                            ConnectionsRow(connections: profile.connections)
                        }
                    }

                    // Career basics
                    section(title: "Career") {
                        CareerGrid(
                            position: profile.currentPosition,
                            company: profile.company,
                            industry: profile.industry,
                            experienceYears: profile.experienceYears
                        )
                    }

                    // Skills
                    if !profile.skills.isEmpty {
                        section(title: "Skills") { wrapChips(profile.skills) }
                    }

                    // Interests
                    if !profile.interests.isEmpty {
                        section(title: "Interests") { wrapChips(profile.interests) }
                    }

                    // Open To
                    if !profile.openTo.isEmpty {
                        section(title: "Open to") { wrapChips(profile.openTo.map { $0.rawValue.capitalized }) }
                    }

                    // Education
                    if !profile.education.isEmpty {
                        section(title: "Education") { educationList }
                    }

                    Spacer(minLength: 88) // for bottom bar spacing
                }
            }
        }
        .overlay(alignment: .bottom) {  actionBar }
        .navigationBarTitleDisplayMode(.inline)
    }


    // MARK: - Subviews

    private var headerIdentity: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.fullName)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(p.secondary)
                    if !profile.headline.isEmpty {
                        Text(profile.headline)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(.ultraThinMaterial.opacity(0.2))
                            .cornerRadius(6)
                    }
                    HStack(spacing: 8) {
                        if profile.isVerified {
                            Text("Verified")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(p.success)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        if let city = profile.city, let country = profile.country {
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

    var educationList: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(profile.education) { e in
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




#Preview {
    UserDetailView(profile: MockProfiles.withConnections(maxPerUser: 5)[0])
        .appTheme()
}
