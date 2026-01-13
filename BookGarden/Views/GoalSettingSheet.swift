//
//  GoalSettingSheet.swift
//  BookGarden
//
//  목표 수정 Sheet
//

import SwiftUI

struct GoalSettingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("yearlyGoal") private var yearlyGoal: Int = 12

    @State private var goalText: String = ""
    @FocusState private var isInputFocused: Bool

    private var goalValue: Int {
        Int(goalText) ?? yearlyGoal
    }

    private var isValid: Bool {
        goalValue >= 1 && goalValue <= 100
    }

    private var hasChanged: Bool {
        goalValue != yearlyGoal
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: AppSpacing.xl) {
                    // Current goal info
                    currentGoalView

                    // Goal Input
                    goalInputView

                    // Quick select buttons
                    quickButtonsView

                    Spacer()

                    // Save Button
                    PrimaryButton(
                        title: "저장",
                        icon: "checkmark.circle.fill",
                        isEnabled: isValid && hasChanged
                    ) {
                        yearlyGoal = goalValue
                        dismiss()
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle("목표 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.secondary)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .onAppear {
            goalText = String(yearlyGoal)
        }
    }

    // MARK: - Current Goal View

    private var currentGoalView: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("현재 목표")
                .font(AppFonts.small())
                .foregroundStyle(AppColors.secondary)

            Text("\(yearlyGoal)권")
                .font(AppFonts.h2())
                .foregroundStyle(AppColors.text)
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

    // MARK: - Goal Input View

    private var goalInputView: some View {
        VStack(spacing: AppSpacing.m) {
            Text("새로운 목표")
                .font(AppFonts.small())
                .foregroundStyle(AppColors.text)

            HStack(spacing: AppSpacing.s) {
                TextField("", text: $goalText)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
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
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

    // MARK: - Quick Buttons

    private var quickButtonsView: some View {
        HStack(spacing: AppSpacing.s) {
            quickButton("6권") { goalText = "6" }
            quickButton("12권") { goalText = "12" }
            quickButton("24권") { goalText = "24" }
            quickButton("52권") { goalText = "52" }
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

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
    GoalSettingSheet()
}
