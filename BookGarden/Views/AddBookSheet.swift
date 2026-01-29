//
//  AddBookSheet.swift
//  BookGarden
//
//  책 등록 모달 (수동 입력)
//

import SwiftUI
import SwiftData

struct AddBookSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<BookPlant> { $0.statusRaw == "growing" })
    private var growingBooks: [BookPlant]

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var totalPages: String = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case title, author, pages
    }

    /// 이미 읽고 있는 책이 있는지 확인
    private var hasGrowingBook: Bool {
        !growingBooks.isEmpty
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(totalPages) ?? 0 > 0
    }

    private var canPlant: Bool {
        isValid && !hasGrowingBook
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: AppSpacing.xl) {
                    // Form
                    VStack(spacing: AppSpacing.m) {
                        inputField(
                            title: "책 제목",
                            placeholder: "읽을 책 제목을 입력하세요",
                            text: $title,
                            field: .title
                        )

                        inputField(
                            title: "저자 (선택)",
                            placeholder: "저자명",
                            text: $author,
                            field: .author
                        )

                        inputField(
                            title: "총 페이지 수",
                            placeholder: "300",
                            text: $totalPages,
                            field: .pages,
                            keyboardType: .numberPad
                        )
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)

                    // Warning if already has growing book
                    if hasGrowingBook {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(AppColors.flower1)
                            Text("이미 읽고 있는 책이 있어요.\n먼저 완독한 후 새 책을 심을 수 있어요.")
                                .font(AppFonts.small())
                                .foregroundStyle(AppColors.secondary)
                        }
                        .padding(AppSpacing.m)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.flower1.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium))
                        .padding(.horizontal, AppSpacing.screenPadding)
                    }

                    Spacer()

                    // Plant Button
                    PrimaryButton(
                        title: "심기",
                        icon: "leaf.fill",
                        isEnabled: canPlant
                    ) {
                        plantBook()
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle("씨앗 심기")
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
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Input Field

    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        field: Field,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppFonts.small())
                .foregroundStyle(AppColors.text)

            TextField(placeholder, text: text)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.text)
                .keyboardType(keyboardType)
                .focused($focusedField, equals: field)
                .padding(AppSpacing.m)
                .background(AppColors.white)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .stroke(
                            focusedField == field ? AppColors.primary.opacity(0.5) : AppColors.gray200,
                            lineWidth: focusedField == field ? 2 : 1
                        )
                )
        }
    }

    // MARK: - Actions

    private func plantBook() {
        guard let pages = Int(totalPages), pages > 0 else { return }

        let book = BookPlant(
            title: title.trimmingCharacters(in: .whitespaces),
            author: author.trimmingCharacters(in: .whitespaces),
            totalPage: pages
        )

        modelContext.insert(book)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddBookSheet()
        .modelContainer(for: BookPlant.self, inMemory: true)
}
