//
//  GardenView.swift
//  BookGarden
//
//  정원 탭: 완독한 책 그리드 + 통계 카드
//

import SwiftUI
import SwiftData

struct GardenView: View {
    @AppStorage("yearlyGoal") private var yearlyGoal: Int = 12
    @Query(
        filter: #Predicate<BookPlant> { $0.statusRaw == "harvested" },
        sort: \BookPlant.harvestedDate,
        order: .reverse
    )
    private var harvestedBooks: [BookPlant]

    @State private var showGoalSheet = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // Stats Card
                StatsCard(
                    harvestedCount: harvestedBooks.count,
                    yearlyGoal: yearlyGoal
                ) {
                    showGoalSheet = true
                }
                .padding(.horizontal, AppSpacing.screenPadding)
                .padding(.bottom, AppSpacing.m)

                if harvestedBooks.isEmpty {
                    emptyStateView
                } else {
                    gridView
                }
            }
        }
        .sheet(isPresented: $showGoalSheet) {
            GoalSettingSheet()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        Text("나의 독서 정원")
            .font(AppFonts.h1())
            .foregroundStyle(AppColors.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.vertical, AppSpacing.l)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.m) {
            Spacer()

            Image(systemName: "leaf.arrow.triangle.circlepath")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.gray300)

            Text("아직 완독한 책이 없어요")
                .font(AppFonts.body())
                .foregroundStyle(AppColors.secondary)

            Text("책을 읽고 물을 주면\n정원에 꽃이 피어나요")
                .font(AppFonts.small())
                .foregroundStyle(AppColors.gray300)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

    // MARK: - Grid View

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppSpacing.m) {
                ForEach(harvestedBooks) { book in
                    GardenItemView(book: book)
                }
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.bottom, AppSpacing.xxl)
        }
    }
}

// MARK: - Garden Item View

struct GardenItemView: View {
    let book: BookPlant

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            // Plant with book cover overlay
            ZStack(alignment: .bottom) {
                SmallPlantView(stage: .mature)

                // Mini book cover
                SmallBookCoverView(coverUrl: book.coverUrl)
                    .scaleEffect(0.5)
                    .offset(y: 10)
            }

            // Book title
            Text(book.title)
                .font(AppFonts.tiny())
                .foregroundStyle(AppColors.text)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            // Harvest date
            if let date = book.harvestedDate {
                Text(date, format: .dateTime.month().day())
                    .font(AppFonts.tiny())
                    .foregroundStyle(AppColors.secondary)
            }
        }
    }
}

// MARK: - Preview

#Preview("Empty") {
    GardenView()
        .modelContainer(for: BookPlant.self, inMemory: true)
}

#Preview("With Books") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookPlant.self, configurations: config)

    let books = [
        ("클린 코드", "로버트 마틴"),
        ("SwiftUI 마스터", "홍길동"),
        ("디자인 패턴", "GoF"),
        ("리팩터링", "마틴 파울러"),
        ("실용주의 프로그래머", "데이비드 토머스")
    ]

    for (title, author) in books {
        let book = BookPlant(
            title: title,
            author: author,
            totalPage: 300,
            currentPage: 300,
            status: .harvested,
            harvestedDate: Date().addingTimeInterval(Double.random(in: -86400*30...0))
        )
        container.mainContext.insert(book)
    }

    return GardenView()
        .modelContainer(container)
}
