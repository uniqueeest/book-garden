//
//  WateringSheet.swift
//  BookGarden
//
//  물주기 모달: 페이지 업데이트
//

import SwiftUI
import SwiftData
import UIKit

struct WateringSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var book: BookPlant
    @AppStorage("lastHarvestedID") private var lastHarvestedID: String = ""

    @State private var newPage: String = ""
    @State private var showHarvestAlert = false
    @FocusState private var isInputFocused: Bool

    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private let stageFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let completionFeedback = UINotificationFeedbackGenerator()

    private var newPageInt: Int {
        Int(newPage) ?? book.currentPage
    }

    private var isValid: Bool {
        let page = newPageInt
        return page > book.currentPage && page <= book.totalPage
    }

    private var willComplete: Bool {
        newPageInt >= book.totalPage
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: AppSpacing.xl) {
                    // Current Progress
                    currentProgressView

                    // Page Input
                    pageInputView

                    // Quick buttons
                    quickButtonsView

                    Spacer()

                    // Record Button
                    PrimaryButton(
                        title: willComplete ? "완독하기" : "기록하기",
                        icon: willComplete ? "checkmark.circle.fill" : "drop.fill",
                        isEnabled: isValid
                    ) {
                        stageFeedback.prepare()
                        completionFeedback.prepare()
                        if willComplete {
                            showHarvestAlert = true
                        } else {
                            recordProgress(to: newPageInt, isCompletion: false)
                            dismiss()
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle("물주기")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: AppSpacing.xxl)
            }
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
            newPage = String(book.currentPage)
        }
        .alert("축하해요!", isPresented: $showHarvestAlert) {
            Button("확인") {
                recordProgress(to: book.totalPage, isCompletion: true)
                dismiss()
            }
        } message: {
            Text("'\(book.title)'을(를) 완독했어요!\n정원에 꽃이 피었습니다 🌸")
        }
    }

    // MARK: - Current Progress

    private var currentProgressView: some View {
        VStack(spacing: AppSpacing.s) {
            Text(book.title)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.text)
                .lineLimit(1)

            Text("현재 \(book.currentPage) / \(book.totalPage) 페이지")
                .font(AppFonts.small())
                .foregroundStyle(AppColors.secondary)

            ProgressBarView(progress: book.progress)
                .padding(.horizontal, AppSpacing.xxl)
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

    // MARK: - Page Input

    private var pageInputView: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("현재 읽은 페이지")
                .font(AppFonts.small())
                .foregroundStyle(AppColors.text)

            HStack(spacing: AppSpacing.s) {
                TextField("", text: $newPage)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.text)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .focused($isInputFocused)
                    .frame(width: 120)
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

                Text("/ \(book.totalPage)")
                    .font(AppFonts.h2())
                    .foregroundStyle(AppColors.secondary)
            }

            if willComplete && isValid {
                Text("완독 달성!")
                    .font(AppFonts.small())
                    .foregroundStyle(AppColors.primary)
                    .padding(.top, AppSpacing.xs)
            }
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

    // MARK: - Quick Buttons

    private var quickButtonsView: some View {
        HStack(spacing: AppSpacing.s) {
            quickButton("+10") { addPages(10) }
            quickButton("+20") { addPages(20) }
            quickButton("+50") { addPages(50) }
            quickButton("끝까지") { newPage = String(book.totalPage) }
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }

    private func quickButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button {
            impactFeedback.impactOccurred()
            action()
        } label: {
            Text(title)
                .font(AppFonts.small())
                .foregroundStyle(AppColors.primary)
                .padding(.horizontal, AppSpacing.m)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Capsule())
        }
    }

    private func addPages(_ count: Int) {
        let current = Int(newPage) ?? book.currentPage
        let newValue = min(current + count, book.totalPage)
        newPage = String(newValue)
    }

    private func recordProgress(to page: Int, isCompletion: Bool) {
        let previousStage = book.growthStage
        book.updateProgress(to: page)
        let newStage = book.growthStage

        if isCompletion {
            completionFeedback.notificationOccurred(.success)
            lastHarvestedID = book.id.uuidString
        } else if newStage != previousStage {
            stageFeedback.impactOccurred()
        }
    }

}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookPlant.self, configurations: config)

    let book = BookPlant(
        title: "클린 코드: 애자일 소프트웨어 장인 정신",
        author: "로버트 마틴",
        totalPage: 300,
        currentPage: 135
    )
    container.mainContext.insert(book)

    return WateringSheet(book: book)
        .modelContainer(container)
}
