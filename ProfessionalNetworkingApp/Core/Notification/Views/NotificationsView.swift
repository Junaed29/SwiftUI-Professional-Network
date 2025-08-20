//
//  NotificationsView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

struct NotificationsView: View {
    @Environment(\.appPalette) private var p
    @State private var vm = NotificationsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $vm.filter) {
                ForEach(NotificationsViewModel.Filter.allCases, id: \.self) { f in
                    Text(title(for: f)).tag(f)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            if vm.isLoading {
                ProgressView().padding(.top, 24); Spacer()
            } else if vm.filtered.isEmpty {
                EmptyStateView(
                        icon: "bell.slash",
                        title: "No notifications",
                        message: "You’re all caught up.",
                        actionTitle: "Refresh",
                        action: { Task { await vm.load() } }
                    )
                    .padding(.horizontal)
                    .padding(.top, 40)
            } else {
                List {
                    ForEach(vm.filtered) { n in
                        NotificationRow(item: n, palette: p)
                            .listRowBackground(p.bg)
                    }
                }
                .listStyle(.plain)
                .background(p.bg)
            }
        }
        .background(p.bg.ignoresSafeArea())
        .navigationTitle("Notifications")
        .task { await vm.load() }
    }

    private func title(for f: NotificationsViewModel.Filter) -> String {
        switch f { case .all: "All"; case .messages: "Messages"; case .matches: "Matches"; case .system: "System" }
    }
}

private struct NotificationRow: View {
    let item: AppNotification
    let palette: AppTheme.Palette

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(backgroundColor.opacity(0.18)).frame(width: 40, height: 40)
                Image(systemName: iconName).foregroundColor(backgroundColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.subheadline.weight(.semibold)).foregroundColor(palette.textPrimary)
                Text(item.message).font(.subheadline).foregroundColor(palette.textSecondary).lineLimit(2)
                Text(item.time).font(.caption).foregroundColor(palette.textSecondary)
            }
            Spacer()
            if item.unread {
                Circle().fill(palette.primary).frame(width: 8, height: 8).padding(.top, 6)
            }
        }
        .padding(.vertical, 8)
    }

    private var iconName: String {
        switch item.kind {
        case .message: "bubble.left.and.bubble.right.fill"
        case .match:   "checkmark.seal.fill"
        case .system:  "bell.badge.fill"
        }
    }
    private var backgroundColor: Color {
        switch item.kind {
        case .message: palette.info
        case .match:   palette.success
        case .system:  palette.warning
        }
    }
}
