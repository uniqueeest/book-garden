//
//  DesignSystem.swift
//  BookGarden
//
//  디자인 스펙 기반 컬러, 폰트, 간격 시스템
//

import SwiftUI

// MARK: - Colors

struct AppColors {
    // Primary Colors
    static let background = Color(hex: "FAFAF9")
    static let primary = Color(hex: "4A7C59")      // Forest Green
    static let secondary = Color(hex: "8D6E63")    // Warm Earth Brown
    static let text = Color(hex: "2D2D2D")         // Soft Charcoal

    // Supporting Colors
    static let white = Color.white
    static let gray100 = Color(hex: "F3F4F6")
    static let gray200 = Color(hex: "E5E7EB")
    static let gray300 = Color(hex: "D1D5DB")

    // Plant Colors (for future pixel art)
    static let stem = Color(hex: "4A7C59")
    static let leaf1 = Color(hex: "66BB6A")
    static let leaf2 = Color(hex: "81C784")
    static let leaf3 = Color(hex: "A5D6A7")
    static let potBody = Color(hex: "8D6E63")
    static let potDark = Color(hex: "795548")
    static let potRim = Color(hex: "A1887F")
    static let potBase = Color(hex: "6D4C41")
    static let soil = Color(hex: "5D4037")
    static let flower1 = Color(hex: "FFB74D")
    static let flower2 = Color(hex: "FFA726")
    static let flowerCenter = Color(hex: "FFF59D")

    // Hover state
    static let primaryHover = Color(hex: "3D6647")
}

// MARK: - Typography

struct AppFonts {
    // Nunito가 없을 경우 시스템 폰트 사용
    static let fontName = "Nunito"

    static func h1() -> Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }

    static func h2() -> Font {
        .system(size: 20, weight: .bold, design: .rounded)
    }

    static func h3() -> Font {
        .system(size: 18, weight: .semibold, design: .rounded)
    }

    static func body() -> Font {
        .system(size: 16, weight: .semibold, design: .rounded)
    }

    static func small() -> Font {
        .system(size: 14, weight: .medium, design: .rounded)
    }

    static func tiny() -> Font {
        .system(size: 12, weight: .medium, design: .rounded)
    }
}

// MARK: - Spacing

struct AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48

    // Common usage
    static let screenPadding: CGFloat = 16
    static let cardPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 24
}

// MARK: - Border Radius

struct AppRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 20
    static let xlarge: CGFloat = 24
    static let round: CGFloat = 100
}

// MARK: - Component Sizes

struct AppSizes {
    // Plant display
    static let plantDisplaySize: CGFloat = 240
    static let plantDisplaySmall: CGFloat = 100

    // Book covers
    static let bookCoverWidth: CGFloat = 72
    static let bookCoverHeight: CGFloat = 96
    static let bookCoverListWidth: CGFloat = 72
    static let bookCoverListHeight: CGFloat = 96

    // Buttons
    static let buttonHeight: CGFloat = 60

    // Tab bar
    static let tabBarHeight: CGFloat = 80
    static let tabIconSize: CGFloat = 24

    // Progress bar
    static let progressBarHeight: CGFloat = 12

    // Progress badge
    static let badgeWidth: CGFloat = 60
    static let badgeHeight: CGFloat = 40
}

// MARK: - Shadows

struct AppShadows {
    // Soft Shadow (카드)
    static let soft = Shadow(
        color: Color.black.opacity(0.06),
        radius: 8,
        x: 0,
        y: 2
    )

    // Medium Shadow (버튼)
    static let medium = Shadow(
        color: AppColors.primary.opacity(0.15),
        radius: 12,
        x: 0,
        y: 4
    )

    // Strong Shadow (모달)
    static let strong = Shadow(
        color: Color.black.opacity(0.12),
        radius: 24,
        x: 0,
        y: 8
    )
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers

extension View {
    func softShadow() -> some View {
        self.shadow(
            color: AppShadows.soft.color,
            radius: AppShadows.soft.radius,
            x: AppShadows.soft.x,
            y: AppShadows.soft.y
        )
    }

    func mediumShadow() -> some View {
        self.shadow(
            color: AppShadows.medium.color,
            radius: AppShadows.medium.radius,
            x: AppShadows.medium.x,
            y: AppShadows.medium.y
        )
    }

    func strongShadow() -> some View {
        self.shadow(
            color: AppShadows.strong.color,
            radius: AppShadows.strong.radius,
            x: AppShadows.strong.x,
            y: AppShadows.strong.y
        )
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
