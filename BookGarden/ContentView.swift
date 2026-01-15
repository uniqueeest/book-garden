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
        TabView(selection: $selectedTab.onChange { _ in
            UISelectionFeedbackGenerator().selectionChanged()
        }) {
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

// MARK: - Binding Extension for onChange

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: BookPlant.self, inMemory: true)
}
