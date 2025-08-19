import SwiftUI

struct ChatsListView: View {
    @Environment(\.appPalette) private var p
    @State private var vm = ChatsListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(p.textSecondary)
                TextField("Search messages", text: $vm.search)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit { Task { await vm.load() } }
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(p.card)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(p.divider))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            if vm.isLoading {
                ProgressView().padding(.top, 24)
                Spacer()
            } else if vm.conversations.isEmpty {
                EmptyStateView(title: "No conversations yet", message: "Start connecting to begin a new chat.")
                    .padding(.horizontal)
                    .padding(.top, 40)
            } else {
                List {
                    ForEach(vm.conversations) { convo in
                        NavigationLink {
                            ChatThreadView(partner: convo.partnerName)
                        } label: {
                            ChatRow(convo: convo, palette: p)
                        }
                        .listRowBackground(p.bg)
                    }
                }
                .listStyle(.plain)
                .background(p.bg)
            }
        }
        .background(p.bg.ignoresSafeArea())
        .navigationTitle("Messages")
        .task { await vm.load() }
    }
}

// MARK: - Row (pure view)
private struct ChatRow: View {
    let convo: Conversation
    let palette: AppTheme.Palette

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(palette.primary.opacity(0.12))
                    .frame(width: 48, height: 48)
                Text(initials(from: convo.partnerName))
                    .font(.headline)
                    .foregroundColor(palette.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(convo.partnerName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(palette.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Text(convo.time)
                        .font(.caption)
                        .foregroundColor(palette.textSecondary)
                }
                Text(convo.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(palette.textSecondary)
                    .lineLimit(1)
            }

            if convo.unreadCount > 0 {
                Text("\(convo.unreadCount)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(palette.alert)
                    .cornerRadius(10)
            }
        }
        .padding(.vertical, 6)
    }

    private func initials(from name: String) -> String {
        let comps = name.split(separator: " ")
        let letters = comps.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }
}