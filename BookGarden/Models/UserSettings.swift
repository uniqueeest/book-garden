//
//  UserSettings.swift
//  BookGarden
//
//  사용자 설정 (@AppStorage 기반)
//

import SwiftUI

class UserSettings: ObservableObject {
    static let shared = UserSettings()

    @AppStorage("yearlyGoal") var yearlyGoal: Int = 12
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    private init() {}
}

// MARK: - Environment Key

struct UserSettingsKey: EnvironmentKey {
    static let defaultValue = UserSettings.shared
}

extension EnvironmentValues {
    var userSettings: UserSettings {
        get { self[UserSettingsKey.self] }
        set { self[UserSettingsKey.self] = newValue }
    }
}
