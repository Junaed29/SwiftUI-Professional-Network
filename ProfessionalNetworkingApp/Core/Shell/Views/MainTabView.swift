//
//  MainTabView.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import SwiftUI

struct MainTabView: View {
    @Environment(\.appRouter) private var router
    @Environment(\.appPalette) private var p
    @State private var vm = MainTabViewModel()

    var body: some View {
        TabView(selection: $vm.selected) {

            // Each tab should own its own NavigationStack for isolated histories.
            NavigationStack {
                HomeView()            // e.g., Core/Discovery/Views/HomeView.swift
                    .navigationTitle("Home")
            }
            .tabItem { Label(TabItem.home.title, systemImage: TabItem.home.systemImage) }
            .tag(TabItem.home)

            NavigationStack {
                ChatsListView()       // Core/Chat/Views/ChatsListView.swift
                    .navigationTitle("Messages")
            }
            .tabItem { Label(TabItem.messages.title, systemImage: TabItem.messages.systemImage) }
            .tag(TabItem.messages)

            NavigationStack {
                NotificationsView()   // Create in a suitable place (Core/Shell/Views or Core/Notifications)
                    .navigationTitle("Notifications")
            }
            .tabItem { Label(TabItem.notifications.title, systemImage: TabItem.notifications.systemImage) }
            .tag(TabItem.notifications)

            NavigationStack {
                ProfileDetailView(userID: "me") // or ProfileHomeView
                    .navigationTitle("Profile")
            }
            .tabItem { Label(TabItem.profile.title, systemImage: TabItem.profile.systemImage) }
            .tag(TabItem.profile)
        }
        // Optional theming for the tab bar background/selection
        .tint(p.primary) // selected item color
        .background(p.bg.ignoresSafeArea())
    }
}
