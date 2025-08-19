// HomeView.swift

import SwiftUI

struct HomeView: View {
    @Environment(\.appPalette) private var p

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            VStack(spacing: 0) {
                header
                SwipeView()
                Spacer(minLength: 0)
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "square.grid.2x2")
                    .font(.title3)
                    .foregroundColor(p.secondary)
                    .padding(AppTheme.Space.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            Spacer()
            Text("Find Match")
                .styled(.headline)
            Spacer()
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.title3)
                    .foregroundColor(p.secondary)
                    .padding(AppTheme.Space.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppTheme.Space.lg)
        .padding(.top, AppTheme.Space.lg)
        .padding(.bottom, AppTheme.Space.sm)
    }
}

#Preview { HomeView().appTheme() }
