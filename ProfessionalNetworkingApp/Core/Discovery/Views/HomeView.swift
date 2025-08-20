// HomeView.swift
//
//  Created by Junaed Chowdhury on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appPalette) private var p
    @State private var viewModel = DiscoveryViewModel(isCircular: false, dailyFreeLimit: nil)

    var body: some View {
        ThemedScreen(usePadding: false, background: .gradient) {
            VStack(spacing: 0) {
                header
                SwipeView(viewModel: viewModel)
                Spacer(minLength: 0)
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: { withAnimation(.spring()) { viewModel.reload() } }) {
                ZStack {
                    Circle().fill(.ultraThinMaterial).frame(width: 36, height: 36)
                    Image(systemName: "arrow.clockwise").foregroundColor(p.secondary)
                }
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
