// SwipeView.swift

import SwiftUI

struct SwipeView: View {
    @Environment(\.appPalette) private var p
    @StateObject private var viewModel = DiscoveryViewModel()

    // Gesture state for the top card
    @State private var dragOffset: CGSize = .zero
    private let threshold: CGFloat = 120

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                deck
                // Reload button (top-left), like screenshot
                Button(action: { withAnimation(.spring()) { viewModel.reload() } }) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial).frame(width: 36, height: 36)
                        Image(systemName: "arrow.clockwise").foregroundColor(p.secondary)
                    }
                }
                .padding(AppTheme.Space.md)
            }
            .padding(.horizontal, AppTheme.Space.lg)
            .padding(.top, AppTheme.Space.lg)

            Spacer(minLength: AppTheme.Space.xl)

            // Bottom controls (optional, helpful for testing)
            HStack(spacing: AppTheme.Space.lg) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        dragOffset = CGSize(width: -threshold * 1.2, height: 0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring()) { completeSwipe(.pass) }
                    }
                } label: {
                    Image(systemName: "xmark").font(.title2.weight(.bold))
                        .foregroundColor(p.alert)
                        .frame(width: 56, height: 56)
                        .background(p.secondary)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        dragOffset = CGSize(width: threshold * 1.2, height: 0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring()) { completeSwipe(.like) }
                    }
                } label: {
                    Image(systemName: "heart.fill").font(.title2.weight(.bold))
                        .foregroundColor(p.secondary)
                        .frame(width: 56, height: 56)
                        .background(p.primary)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }
            }
            .padding(.bottom, AppTheme.Space.xl)
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
                        .animation(.spring(), value: viewModel.cards)
                        .animation(.spring(), value: dragOffset)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 480, maxHeight: 560)
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

#Preview { SwipeView().appTheme() }
