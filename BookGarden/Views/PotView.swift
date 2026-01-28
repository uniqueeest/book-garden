//
//  PotView.swift
//  BookGarden
//
//  화분 탭: 현재 읽는 책 표시 + 물주기
//

import SwiftUI
import SwiftData

struct PotView: View {
    @AppStorage("yearlyGoal") private var yearlyGoal: Int = 12
    @Binding var selectedTab: AppTab
    @Query(filter: #Predicate<BookPlant> { $0.statusRaw == "growing" })
    private var growingBooks: [BookPlant]
    @Query(
        filter: #Predicate<BookPlant> { $0.statusRaw == "harvested" },
        sort: \BookPlant.harvestedDate,
        order: .reverse
    )
    private var harvestedBooks: [BookPlant]

    @State private var showAddBookSheet = false
    @State private var showWateringSheet = false
    @State private var showHarvestToast = false
    @State private var harvestToastTitle = ""
    @State private var previousHarvestCount = 0
    @State private var hideHarvestToastTask: Task<Void, Never>?

    var currentBook: BookPlant? {
        growingBooks.first
    }

    /// 올해 수확한 책 수 (자동 갱신)
    private var harvestedThisYear: Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return harvestedBooks.filter { book in
            guard let date = book.harvestedDate else { return false }
            return calendar.component(.year, from: date) == currentYear
        }.count
    }

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                Spacer()

                if let book = currentBook {
                    growingStateView(book: book)
                } else {
                    emptyStateView
                }

                Spacer()
            }
            .padding(.horizontal, AppSpacing.screenPadding)

            if showHarvestToast {
                harvestToastView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .sheet(isPresented: $showAddBookSheet) {
            AddBookSheet()
        }
        .sheet(isPresented: $showWateringSheet) {
            if let book = currentBook {
                WateringSheet(book: book)
            }
        }
        .onAppear {
            previousHarvestCount = harvestedBooks.count
        }
        .onChange(of: harvestedBooks.count) { _, newValue in
            guard newValue > previousHarvestCount else {
                previousHarvestCount = newValue
                return
            }

            let currentToastTitle = harvestedBooks.first?.title ?? "책"
            harvestToastTitle = currentToastTitle
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                showHarvestToast = true
            }

            previousHarvestCount = newValue
            hideHarvestToastTask?.cancel()
            hideHarvestToastTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_600_000_000)
                if harvestToastTitle == currentToastTitle {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showHarvestToast = false
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("올해의 농사: \(harvestedThisYear)/\(yearlyGoal)권")
                .font(AppFonts.h3())
                .foregroundStyle(AppColors.text)

            Spacer()

            Button {
                // TODO: 알림 기능
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.secondary)
                    .frame(width: 40, height: 40)
            }
        }
        .frame(height: 60)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.xxl) {
            PlantView(stage: .empty)

            Text("아직 심은 책이 없어요")
                .font(AppFonts.body())
                .foregroundStyle(AppColors.secondary)

            PrimaryButton(
                title: "씨앗 심기",
                icon: "leaf.fill"
            ) {
                showAddBookSheet = true
            }
        }
    }

    // MARK: - Growing State

    private func growingStateView(book: BookPlant) -> some View {
        VStack(spacing: AppSpacing.xl) {
            // Plant with progress badge
            PlantView(
                stage: book.growthStage,
                showBadge: true,
                progress: book.progressPercent
            )

            // Book Info Card
            BookInfoCard(book: book)

            // Watering Button
            PrimaryButton(
                title: "물주기",
                icon: "drop.fill"
            ) {
                showWateringSheet = true
            }
        }
    }

    // MARK: - Harvest Toast

    private var harvestToastView: some View {
        VStack {
            Spacer()

            HStack(spacing: AppSpacing.m) {
                SmallPlantView(stage: .mature)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("수확 완료")
                        .font(AppFonts.small())
                        .foregroundStyle(AppColors.secondary)
                    Text("'\(harvestToastTitle)'이(가) 정원에 옮겨졌어요")
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.text)
                        .lineLimit(2)
                }

                Spacer()

                Button("정원 보기") {
                    selectedTab = .garden
                }
                .font(AppFonts.small())
                .foregroundStyle(AppColors.primary)
            }
            .padding(AppSpacing.m)
            .background(AppColors.white)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.large))
            .softShadow()
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.bottom, AppSpacing.xl)
        }
    }

}

// MARK: - Preview

#Preview("Empty State") {
    PotView(selectedTab: .constant(.pot))
        .modelContainer(for: BookPlant.self, inMemory: true)
}

#Preview("Growing State") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookPlant.self, configurations: config)

    let book = BookPlant(
        title: "클린 코드",
        author: "로버트 마틴",
        totalPage: 300,
        currentPage: 135
    )
    container.mainContext.insert(book)

    return PotView(selectedTab: .constant(.pot))
        .modelContainer(container)
}
