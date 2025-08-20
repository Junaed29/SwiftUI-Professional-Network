// ProfileCardView.swift
//
//  Created by Junaed Chowdhury on 19/8/25.
//

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
                .padding(AppTheme.Space.xs)
        }
        .frame(maxWidth: .infinity, minHeight: 420)
    }

    private var photo: some View {
        Group {
            if let url = card.avatarURL {
                ImageLoader(url: url, contentMode: .fill)
            } else {
                ZStack {
                    p.bgAlt
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(p.textSecondary)
                }
            }
        }
        .overlay(alignment: .topTrailing) { flameBadge.padding(AppTheme.Space.sm) }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: AppTheme.Space.xs) {
            Text(card.fullName)
                .font(.title3.weight(.semibold))
                .foregroundColor(p.secondary)
            if !card.headline.isEmpty {
                Text(card.headline).styled(.caption, color: p.secondary.opacity(0.9))
            }
            HStack(spacing: AppTheme.Space.xs) {
                if let tag = card.industry ?? card.skills.first {
                    ChipView(text: tag, outline: true)
                        .styled(.caption)
                }
                if let city = card.city, let country = card.country {
                    Text("\(city), \(country)")
                        .styled(.caption2, color: p.secondary.opacity(0.9))
                }
                Spacer()
            }
        }
        .shadow(color: .black.opacity(0.7), radius: 6, y: 3)
        .padding(AppTheme.Space.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.95)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, AppTheme.Space.lg)
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
        fullName: "Sophia Martinez",
        headline: "iOS Developer @ Beyond ITL",
        bio: "Passionate about SwiftUI.",
        avatarURL: URL(string: "https://i.pravatar.cc/500?img=1"),
        isVerified: true,
        city: "Kuala Lumpur",
        country: "Malaysia",
        currentPosition: "iOS Developer",
        company: "Beyond ITL",
        industry: "IT",
        experienceYears: 4,
        education: [],
        skills: ["Swift", "SwiftUI"],
        interests: ["AI"],
        openTo: [.collaboration],
        connections: []
    ))
    .appTheme()
}
