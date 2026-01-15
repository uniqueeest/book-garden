//
//  PlantView.swift
//  BookGarden
//
//  식물 뷰 컴포넌트 (SF Symbols 임시 사용 → 추후 픽셀아트/SVG로 교체)
//

import SwiftUI

struct PlantView: View {
    let stage: GrowthStage
    var size: CGFloat = AppSizes.plantDisplaySize
    var showBadge: Bool = false
    var progress: Int = 0

    @State private var isAnimating = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Plant Container
            VStack {
                Spacer()

                // Plant Icon with gentle animation
                Image(systemName: stage.symbolName)
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(plantColor)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(stage != .empty && isAnimating ? 1.05 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                // Pot
                PotShape()
                    .fill(AppColors.potBody)
                    .frame(width: size * 0.4, height: size * 0.25)
                    .overlay(
                        PotShape()
                            .stroke(AppColors.potRim, lineWidth: 2)
                    )
            }
            .frame(width: size, height: size)

            // Progress Badge
            if showBadge && progress > 0 {
                ProgressBadge(progress: progress)
                    .offset(x: -AppSpacing.m, y: AppSpacing.m)
            }
        }
        .task(id: stage) {
            isAnimating = (stage != .empty)
        }
    }

    private var plantColor: Color {
        switch stage {
        case .empty:
            return AppColors.gray300
        case .seed, .sprout:
            return AppColors.leaf3
        case .growing:
            return AppColors.leaf1
        case .flowering:
            return AppColors.flower1
        case .mature:
            return AppColors.primary
        }
    }
}

// MARK: - Pot Shape

struct PotShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topWidth = rect.width
        let bottomWidth = rect.width * 0.7
        let rimHeight = rect.height * 0.15

        // Rim
        path.addRoundedRect(
            in: CGRect(x: 0, y: 0, width: topWidth, height: rimHeight),
            cornerSize: CGSize(width: 4, height: 4)
        )

        // Body (trapezoid)
        let bodyTop = rimHeight
        let inset = (topWidth - bottomWidth) / 2

        path.move(to: CGPoint(x: inset * 0.3, y: bodyTop))
        path.addLine(to: CGPoint(x: topWidth - inset * 0.3, y: bodyTop))
        path.addLine(to: CGPoint(x: topWidth - inset, y: rect.height))
        path.addLine(to: CGPoint(x: inset, y: rect.height))
        path.closeSubpath()

        return path
    }
}

// MARK: - Progress Badge

struct ProgressBadge: View {
    let progress: Int

    var body: some View {
        Text("\(progress)%")
            .font(AppFonts.h3())
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.s)
            .padding(.vertical, AppSpacing.xs)
            .background(AppColors.primary)
            .clipShape(Capsule())
            .mediumShadow()
    }
}

// MARK: - Small Plant View (for Garden Grid)

struct SmallPlantView: View {
    let stage: GrowthStage

    var body: some View {
        PlantView(
            stage: stage,
            size: AppSizes.plantDisplaySmall,
            showBadge: false
        )
    }
}

// MARK: - Preview

#Preview("Growth Stages") {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            PlantView(stage: .empty, size: 100)
            PlantView(stage: .seed, size: 100)
            PlantView(stage: .sprout, size: 100)
        }
        HStack(spacing: 20) {
            PlantView(stage: .growing, size: 100)
            PlantView(stage: .flowering, size: 100)
            PlantView(stage: .mature, size: 100)
        }
    }
    .padding()
    .background(AppColors.background)
}

#Preview("With Badge") {
    PlantView(
        stage: .growing,
        size: 240,
        showBadge: true,
        progress: 45
    )
    .padding()
    .background(AppColors.background)
}
