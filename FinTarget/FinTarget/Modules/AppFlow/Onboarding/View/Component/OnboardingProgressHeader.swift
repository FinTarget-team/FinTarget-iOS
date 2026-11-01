//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

struct OnboardingProgressHeader: View {

    let currentStep: Int
    let totalSteps: Int
    let backAction: () -> Void

    var body: some View {
        HStack(spacing: 24) {

            // MARK: - Back Button

            Button {
                backAction()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(red: 0.30, green: 0.37, blue: 0.47))
            }

            // MARK: - Progress Bar

            ProgressView(
                value: Double(currentStep),
                total: Double(max(totalSteps, 1))
            )
            .tint(Color(red: 0.20, green: 0.39, blue: 0.91))

            // MARK: - Step Count

            Text("\(currentStep) / \(totalSteps)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(red: 0.30, green: 0.37, blue: 0.47))
                .fixedSize()
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .background(Color(.systemGray6))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.12))
                .frame(height: 1)
        }
    }
}










