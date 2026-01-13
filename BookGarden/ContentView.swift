//
//  ContentView.swift
//  BookGarden
//
//  메인 TabView: 화분 / 정원 + 온보딩
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var selectedTab: Tab = .pot
    @State private var showOnboarding: Bool = false

    enum Tab {
        case pot
        case garden
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            PotView()
                .tag(Tab.pot)
                .tabItem {
                    Label("화분", systemImage: selectedTab == .pot ? "leaf.fill" : "leaf")
                }

            GardenView()
                .tag(Tab.garden)
                .tabItem {
                    Label("정원", systemImage: selectedTab == .garden ? "tree.fill" : "tree")
                }
        }
        .tint(AppColors.primary)
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                showOnboarding = false
            }
        }
        .onAppear {
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: BookPlant.self, inMemory: true)
}
