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

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var totalPages: String = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case title, author, pages
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(totalPages) ?? 0 > 0
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

                    Spacer()

                    // Plant Button
                    PrimaryButton(
                        title: "심기",
                        icon: "leaf.fill",
                        isEnabled: isValid
                    ) {
                        plantBook()
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle("씨앗 심기")
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
