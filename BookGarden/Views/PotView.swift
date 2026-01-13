//
//  PotView.swift
//  BookGarden
//
//  화분 탭: 현재 읽는 책 표시 + 물주기
//

import SwiftUI
import SwiftData

struct PotView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.userSettings) private var settings
    @Query(filter: #Predicate<BookPlant> { $0.statusRaw == "growing" })
    private var growingBooks: [BookPlant]

    @State private var showAddBookSheet = false
    @State private var showWateringSheet = false
    @State private var harvestedBooksCount: Int = 0

    var currentBook: BookPlant? {
        growingBooks.first
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
        }
        .sheet(isPresented: $showAddBookSheet) {
            AddBookSheet()
        }
        .sheet(isPresented: $showWateringSheet) {
            if let book = currentBook {
                WateringSheet(book: book)
            }
        }
        .task {
            await updateHarvestedCount()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("올해의 농사: \(harvestedBooksCount)/\(settings.yearlyGoal)권")
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

    // MARK: - Helper Methods

    @MainActor
    private func updateHarvestedCount() async {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())

        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else {
            harvestedBooksCount = 0
            return
        }

        let descriptor = FetchDescriptor<BookPlant>(
            predicate: #Predicate<BookPlant> {
                $0.statusRaw == "harvested" &&
                $0.harvestedDate != nil &&
                $0.harvestedDate! >= startOfYear
            }
        )

        do {
            let count = try modelContext.fetchCount(descriptor)
            harvestedBooksCount = count
        } catch {
            harvestedBooksCount = 0
        }
    }
}

// MARK: - Preview

#Preview("Empty State") {
    PotView()
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

    return PotView()
        .modelContainer(container)
}
