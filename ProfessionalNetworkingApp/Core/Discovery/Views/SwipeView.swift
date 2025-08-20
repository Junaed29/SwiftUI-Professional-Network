// SwipeView.swift

import SwiftUI

struct SwipeView: View {
    @Environment(\.appPalette) private var p
    @ObservedObject var viewModel: DiscoveryViewModel

    // Gesture state for the top card
    @State private var dragOffset: CGSize = .zero
    private let threshold: CGFloat = 120

    // Navigation state
    @State private var selectedProfile: UserCard? = nil
    @State private var showDetail: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                if gateActive {
                    gateView
                        .padding(.horizontal, AppTheme.Space.lg)
                        .padding(.top, AppTheme.Space.lg)
                } else {
                    deck
                        .padding(.horizontal, AppTheme.Space.lg)
                        .padding(.top, AppTheme.Space.lg)
                }
            }
            // Modern navigation API
            .navigationDestination(isPresented: $showDetail) {
                Group {
                    if let profile = selectedProfile { UserDetailView(profile: profile) } else { EmptyView() }
                }
            }

            Spacer(minLength: AppTheme.Space.xl)

            // Bottom controls
            HStack(spacing: AppTheme.Space.lg) {
                Button { animatePass() } label: {
                    Image(systemName: "xmark").font(.title2.weight(.bold))
                        .foregroundColor(p.alert)
                        .frame(width: 56, height: 56)
                        .background(p.secondary)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }
                Button { animateLike() } label: {
                    Image(systemName: "heart.fill").font(.title2.weight(.bold))
                        .foregroundColor(p.secondary)
                        .frame(width: 56, height: 56)
                        .background(p.primary)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }
            }
            .padding(.bottom, AppTheme.Space.sm)
            .disabled(gateActive)
        }
    }

    private var gateActive: Bool {
        viewModel.reachedDailyLimit || (!viewModel.isCircular && viewModel.cards.isEmpty)
    }

    private var gateView: some View {
        VStack(spacing: AppTheme.Space.lg) {
            ThemedCard(style: .elevated) {
                VStack(spacing: AppTheme.Space.md) {
                    Image(systemName: viewModel.reachedDailyLimit ? "lock.fill" : "clock.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(p.primary)
                    Text(viewModel.reachedDailyLimit ? "You're out of free profile views" : "No more profiles")
                        .styled(.title3)
                        .multilineTextAlignment(.center)
                    Text(viewModel.reachedDailyLimit ? "Come back tomorrow for more, or subscribe to unlock unlimited swipes." : "Check back later or reload to start over.")
                        .styled(.body, color: p.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Space.lg)
                    if let limit = viewModel.dailyFreeLimit {
                        let remaining = max(0, limit - viewModel.swipesToday)
                        if remaining == 0 {
                            Text("Daily limit reached").styled(.caption2, color: p.textSecondary)
                        } else {
                            Text("\(remaining) views left today").styled(.caption2, color: p.textSecondary)
                        }
                    }
                    HStack(spacing: AppTheme.Space.md) {
                        Button("Reload") { withAnimation(.spring()) { viewModel.reload() } }
                            .buttonStyle(OutlineButtonStyle())
                        Button("Get Premium") { /* TODO: present paywall */ }
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 420)
        }
    }

    private var deck: some View {
        ZStack {
            if viewModel.cards.isEmpty {
                Text("You're all caught up!")
                    .styled(.body, color: p.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: 420)
                    .background(p.bgAlt)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                    let isTop = index == 0
                    ProfileCardView(card: card)
                        .offset(isTop ? dragOffset : .zero)
                        .rotationEffect(.degrees(isTop ? Double(dragOffset.width / 12) : 0))
                        .scaleEffect(scale(for: index))
                        .offset(y: CGFloat(index) * 8)
                        .zIndex(Double(viewModel.cards.count - index))
                        .shadow(color: .black.opacity(isTop ? 0.2 : 0.08), radius: isTop ? 12 : 6, y: 4)
                        .gesture(isTop ? dragGesture : nil)
                        .overlay(alignment: .center) { likePassOverlay(opacity: overlayOpacity()) }
                        .onTapGesture { if isTop { selectedProfile = card; showDetail = true } }
                        .animation(.spring(), value: viewModel.cards)
                        .animation(.spring(), value: dragOffset)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 480, maxHeight: 560)
    }

    private func animatePass() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { dragOffset = CGSize(width: -threshold * 1.2, height: 0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { withAnimation(.spring()) { completeSwipe(.pass) } }
    }
    private func animateLike() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { dragOffset = CGSize(width: threshold * 1.2, height: 0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { withAnimation(.spring()) { completeSwipe(.like) } }
    }

    private func scale(for index: Int) -> CGFloat {
        switch index {
        case 0: return 1.0
        case 1: return 0.98
        default: return 0.96
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > threshold {
                    withAnimation(.spring()) { completeSwipe(.like) }
                } else if value.translation.width < -threshold {
                    withAnimation(.spring()) { completeSwipe(.pass) }
                } else {
                    withAnimation(.spring()) { dragOffset = .zero }
                }
            }
    }

    private func completeSwipe(_ action: SwipeAction) {
        dragOffset = .zero
        viewModel.handle(action)
    }

    private func overlayOpacity() -> Double {
        let absX = abs(dragOffset.width)
        return min(Double(absX / threshold), 1.0)
    }

    @ViewBuilder
    private func likePassOverlay(opacity: Double) -> some View {
        if opacity > 0.05 {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: dragOffset.width >= 0 ? "heart.fill" : "xmark")
                        .font(.title.weight(.bold))
                        .foregroundColor(dragOffset.width >= 0 ? p.primary : p.alert)
                )
                .opacity(opacity)
        }
    }
}

#Preview {
    SwipeView(viewModel: DiscoveryViewModel())
        .appTheme()
}
