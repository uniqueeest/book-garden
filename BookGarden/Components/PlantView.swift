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
    var fillFrame: Bool = false

    @State private var isAnimating = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if fillFrame {
                    Image(stage.assetName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipped()
                } else {
                    Image(stage.assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                }
            }
            .scaleEffect(stage != .empty && isAnimating ? 1.03 : 1.0)
            .offset(y: stage != .empty && isAnimating ? -2 : 0)
            .animation(
                .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .id(stage)
            .transition(.opacity.combined(with: .scale))
            .animation(.easeInOut(duration: 0.25), value: stage)

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
            showBadge: false,
            fillFrame: true
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
