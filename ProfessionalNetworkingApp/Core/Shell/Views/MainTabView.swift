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
        ThemedScreen(usePadding: false, background: .gradient) {
            TabView(selection: $vm.selected) {

                // Each tab should own its own NavigationStack for isolated histories.
 //               NavigationStack {
                    HomeView()
                        .navigationTitle("Home")
 //               }
                .tabItem { Label(TabItem.home.title, systemImage: TabItem.home.systemImage) }
                .tag(TabItem.home)

//                NavigationStack {
                    ChatsListView()
                        .navigationTitle("Messages")
//                }
                .tabItem { Label(TabItem.messages.title, systemImage: TabItem.messages.systemImage) }
                .tag(TabItem.messages)

//                NavigationStack {
                    NotificationsView()
                        .navigationTitle("Notifications")
//                }
                .tabItem { Label(TabItem.notifications.title, systemImage: TabItem.notifications.systemImage) }
                .tag(TabItem.notifications)

//                NavigationStack {
                    ProfileDetailView(userID: "me")
                        .navigationTitle("Profile")
 //               }
                .tabItem { Label(TabItem.profile.title, systemImage: TabItem.profile.systemImage) }
                .tag(TabItem.profile)
            }
            .tint(p.primary) // selected item color
        }
    }
}
