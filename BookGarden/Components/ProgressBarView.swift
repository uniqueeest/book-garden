//
//  ProgressBarView.swift
//  BookGarden
//
//  읽기 진행률 바 컴포넌트
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var height: CGFloat = AppSizes.progressBarHeight
    var backgroundColor: Color = AppColors.gray100
    var foregroundColor: Color = AppColors.primary
    var animated: Bool = true

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: AppRadius.round)
                    .fill(backgroundColor)

                // Progress
                RoundedRectangle(cornerRadius: AppRadius.round)
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * min(max(progress, 0), 1))
                    .animation(animated ? .easeOut(duration: 0.5) : nil, value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ProgressBarView(progress: 0)
        ProgressBarView(progress: 0.25)
        ProgressBarView(progress: 0.5)
        ProgressBarView(progress: 0.75)
        ProgressBarView(progress: 1.0)
    }
    .padding()
    .background(AppColors.background)
}
