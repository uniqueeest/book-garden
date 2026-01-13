//
//  UserSettings.swift
//  BookGarden
//
//  사용자 설정 키 상수
//  각 뷰에서 @AppStorage로 직접 사용
//

import Foundation

/// AppStorage 키 상수
enum AppStorageKeys {
    static let yearlyGoal = "yearlyGoal"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}

/// 기본값 상수
enum AppDefaults {
    static let yearlyGoal = 12
}
