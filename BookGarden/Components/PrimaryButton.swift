//
//  PrimaryButton.swift
//  BookGarden
//
//  공통 Primary 버튼 컴포넌트
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(AppFonts.h3())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppSizes.buttonHeight)
            .background(isEnabled ? AppColors.primary : AppColors.gray300)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xlarge))
            .mediumShadow()
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(
            title: "씨앗 심기",
            icon: "leaf.fill"
        ) {
            print("Tapped!")
        }

        PrimaryButton(
            title: "물주기",
            icon: "drop.fill"
        ) {
            print("Tapped!")
        }

        PrimaryButton(
            title: "비활성 버튼",
            icon: "xmark",
            isEnabled: false
        ) {
            print("Tapped!")
        }
    }
    .padding()
    .background(AppColors.background)
}
