//
//  StatsCard.swift
//  BookGarden
//
//  정원 탭 상단 통계 카드
//

import SwiftUI

struct StatsCard: View {
    let harvestedCount: Int
    let yearlyGoal: Int
    var onTap: () -> Void

    private var progress: Double {
        guard yearlyGoal > 0 else { return 0 }
        return min(Double(harvestedCount) / Double(yearlyGoal), 1.0)
    }

    private var progressPercent: Int {
        Int(progress * 100)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.m) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(AppColors.gray200, lineWidth: 6)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(AppColors.primary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 0.5), value: progress)

                    VStack(spacing: 0) {
                        Text("\(progressPercent)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.primary)
                        Text("%")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(AppColors.secondary)
                    }
                }
                .frame(width: 60, height: 60)

                // Stats Info
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("올해의 농사")
                        .font(AppFonts.small())
                        .foregroundStyle(AppColors.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xxs) {
                        Text("\(harvestedCount)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.text)

                        Text("/ \(yearlyGoal)권")
                            .font(AppFonts.body())
                            .foregroundStyle(AppColors.secondary)
                    }
                }

                Spacer()

                // Edit Icon
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(AppColors.gray300)
            }
            .padding(AppSpacing.l)
            .background(AppColors.white)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xlarge))
            .softShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        StatsCard(harvestedCount: 3, yearlyGoal: 12) {
            print("Tapped!")
        }

        StatsCard(harvestedCount: 10, yearlyGoal: 12) {
            print("Tapped!")
        }

        StatsCard(harvestedCount: 12, yearlyGoal: 12) {
            print("Tapped!")
        }
    }
    .padding()
    .background(AppColors.background)
}
