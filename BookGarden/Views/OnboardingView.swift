//
//  OnboardingView.swift
//  BookGarden
//
//  첫 실행 온보딩: 목표 설정
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("yearlyGoal") private var yearlyGoal: Int = 12
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var goalText: String = "12"
    @FocusState private var isInputFocused: Bool

    var onComplete: () -> Void

    private var goalValue: Int {
        Int(goalText) ?? 12
    }

    private var isValid: Bool {
        goalValue >= 1 && goalValue <= 100
    }

    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: AppSpacing.xxl) {
                Spacer()

                // Welcome Icon
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(AppColors.primary)
                    .symbolRenderingMode(.hierarchical)

                // Welcome Text
                VStack(spacing: AppSpacing.s) {
                    Text("북가든에 오신 걸 환영해요!")
                        .font(AppFonts.h1())
                        .foregroundStyle(AppColors.text)

                    Text("책을 읽으면 정원이 자라나요")
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.secondary)
                }

                Spacer()

                // Goal Input
                VStack(spacing: AppSpacing.m) {
                    Text("올해 몇 권 읽을 목표인가요?")
                        .font(AppFonts.h3())
                        .foregroundStyle(AppColors.text)

                    HStack(spacing: AppSpacing.s) {
                        TextField("", text: $goalText)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .focused($isInputFocused)
                            .frame(width: 100)
                            .padding(.vertical, AppSpacing.m)
                            .background(AppColors.white)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.medium)
                                    .stroke(
                                        isInputFocused ? AppColors.primary.opacity(0.5) : AppColors.gray200,
                                        lineWidth: isInputFocused ? 2 : 1
                                    )
                            )

                        Text("권")
                            .font(AppFonts.h2())
                            .foregroundStyle(AppColors.secondary)
                    }

                    // Quick select buttons
                    HStack(spacing: AppSpacing.s) {
                        quickButton("6권") { goalText = "6" }
                        quickButton("12권") { goalText = "12" }
                        quickButton("24권") { goalText = "24" }
                        quickButton("52권") { goalText = "52" }
                    }
                }

                Spacer()

                // Start Button
                PrimaryButton(
                    title: "시작하기",
                    icon: "arrow.right.circle.fill",
                    isEnabled: isValid
                ) {
                    yearlyGoal = goalValue
                    hasCompletedOnboarding = true
                    onComplete()
                }
                .padding(.horizontal, AppSpacing.screenPadding)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .onAppear {
            goalText = String(yearlyGoal)
        }
    }

    // MARK: - Quick Button

    private func quickButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.small())
                .foregroundStyle(AppColors.primary)
                .padding(.horizontal, AppSpacing.m)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Capsule())
        }
    }

}

// MARK: - Preview

#Preview {
    OnboardingView {
        print("Onboarding completed!")
    }
}
