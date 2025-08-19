import SwiftUI

struct ChatThreadView: View {
    @Environment(\.appPalette) private var p
    @State private var vm: ChatThreadViewModel

    init(partner: String) {
        _vm = State(initialValue: ChatThreadViewModel(partner: partner))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.messages) { msg in
                            HStack {
                                if msg.isMe { Spacer(minLength: 40) }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(msg.text)
                                        .foregroundColor(msg.isMe ? .white : p.textPrimary)
                                        .padding(10)
                                        .background(msg.isMe ? p.primary : p.card)
                                        .cornerRadius(12)
                                    Text(msg.time)
                                        .font(.caption2)
                                        .foregroundColor(p.textSecondary)
                                }
                                if !msg.isMe { Spacer(minLength: 40) }
                            }
                            .padding(.horizontal)
                            .id(msg.id)
                        }
                    }
                    .padding(.top, 8)
                }
                .background(p.bg)
                .onChange(of: vm.messages.count) { _ in
                    withAnimation { proxy.scrollTo(vm.messages.last?.id, anchor: .bottom) }
                }
            }

            // Input bar
            HStack(spacing: 8) {
                TextField("Message \(vm.partner)", text: $vm.input, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(10)
                    .background(p.card)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(p.divider))
                    .cornerRadius(10)

                Button {
                    Task { await vm.send() }
                } label: {
                    Image(systemName: vm.isSending ? "hourglass" : "paperplane.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(p.primary)
                        .cornerRadius(10)
                }
                .disabled(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isSending)
                .opacity(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            }
            .padding(.all, 12)
            .background(p.bgAlt.ignoresSafeArea(edges: .bottom))
        }
        .navigationTitle(vm.partner)
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }
}