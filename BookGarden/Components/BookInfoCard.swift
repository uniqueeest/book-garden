//
//  BookInfoCard.swift
//  BookGarden
//
//  책 정보 카드 컴포넌트
//

import SwiftUI

struct BookInfoCard: View {
    let book: BookPlant

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            // Book Cover Placeholder
            BookCoverView(coverUrl: book.coverUrl)

            // Book Info
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(book.title)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.text)
                    .lineLimit(2)

                Text("\(book.currentPage) / \(book.totalPage) 페이지")
                    .font(AppFonts.small())
                    .foregroundStyle(AppColors.secondary)

                Spacer()

                // Progress Bar
                ProgressBarView(progress: book.progress)
            }
        }
        .padding(AppSpacing.l)
        .background(AppColors.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xlarge))
        .softShadow()
    }
}

// MARK: - Book Cover View

struct BookCoverView: View {
    let coverUrl: String?
    var width: CGFloat = AppSizes.bookCoverWidth
    var height: CGFloat = AppSizes.bookCoverHeight

    var body: some View {
        Group {
            if let urlString = coverUrl, let _ = URL(string: urlString) {
                // TODO: AsyncImage로 네트워크 이미지 로드
                placeholderCover
            } else {
                placeholderCover
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
        .softShadow()
    }

    private var placeholderCover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.small)
                .fill(AppColors.gray200)

            Image(systemName: "book.closed.fill")
                .font(.system(size: 24))
                .foregroundStyle(AppColors.secondary)
        }
    }
}

// MARK: - Small Book Cover (for list items)

struct SmallBookCoverView: View {
    let coverUrl: String?

    var body: some View {
        BookCoverView(
            coverUrl: coverUrl,
            width: AppSizes.bookCoverListWidth,
            height: AppSizes.bookCoverListHeight
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        BookInfoCard(
            book: BookPlant(
                title: "클린 코드: 애자일 소프트웨어 장인 정신",
                author: "로버트 C. 마틴",
                totalPage: 300,
                currentPage: 135
            )
        )

        BookInfoCard(
            book: BookPlant(
                title: "SwiftUI 마스터하기",
                author: "홍길동",
                totalPage: 500,
                currentPage: 50
            )
        )
    }
    .padding()
    .background(AppColors.background)
}
