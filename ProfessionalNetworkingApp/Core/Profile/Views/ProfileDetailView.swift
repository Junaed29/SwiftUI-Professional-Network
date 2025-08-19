// Core/Profile/Views/ProfileDetailView.swift
import SwiftUI

struct ProfileDetailView: View {
    // For “other user” profile we usually load by id
    let userID: String

    @Environment(\.appPalette) private var p  // if you use AppTheme; remove if not
    @State private var vm = ProfileViewModel()
    @State private var showFullBio = false

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
                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.profile.bio)
                            .foregroundColor(p.textPrimary)
                            .lineLimit(showFullBio ? nil : 3)
                        if vm.profile.bio.count > 120 {
                            Button(showFullBio ? "Show less" : "Show more") {
                                withAnimation(.easeInOut) { showFullBio.toggle() }
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(p.primary)
                        }
                    }
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
                        FlowChips(vm.profile.interests, color: p.textSecondary.opacity(0.18), textColor: p.textPrimary)
                    }
                }

                // Looking for
                if !vm.profile.lookingFor.isEmpty {
                    section(title: "Looking for") {
                        FlowChips(vm.profile.lookingFor, color: p.primary.opacity(0.16), textColor: p.textPrimary)
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

// MARK: - Header hero image with gradient
private struct HeaderHero: View {
    @Environment(\.appPalette) private var p
    let imageURL: URL?

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty: Rectangle().fill(p.card).frame(height: 360)
                case .success(let img): img.resizable().scaledToFill().frame(height: 360).clipped()
                case .failure: Rectangle().fill(p.card).frame(height: 360)
                @unknown default: Rectangle().fill(p.card).frame(height: 360)
                }
            }
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

// MARK: - Friends avatars row
private struct FriendsRow: View {
    @Environment(\.appPalette) private var p
    let friends: [Friend]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(friends) { f in
                    AsyncImage(url: f.avatarURL) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(p.card)
                    }
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

// MARK: - Flow chips
private struct FlowChips: View {
    let items: [String]
    let color: Color
    let textColor: Color
    var body: some View {
        FlexibleWrap(items, spacing: 8, runSpacing: 8) { text in
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(color)
                .foregroundColor(textColor)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.35)))
                .cornerRadius(10)
        }
    }
}

// MARK: - Simple wrap layout (works well for chips)
private struct FlexibleWrap<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let runSpacing: CGFloat
    @ViewBuilder let content: (Data.Element) -> Content

    init(_ data: Data, spacing: CGFloat, runSpacing: CGFloat, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data; self.spacing = spacing; self.runSpacing = runSpacing; self.content = content
    }

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > UIScreen.main.bounds.width - 32 {
                            width = 0; height -= d.height + runSpacing
                        }
                        let result = width
                        width -= d.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { _ in height }
            }
        }
    }
}