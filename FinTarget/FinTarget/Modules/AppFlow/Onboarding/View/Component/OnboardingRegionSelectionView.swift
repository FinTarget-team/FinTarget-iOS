//
//  OnboardingRegionSelectionView.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

struct OnboardingRegionSelectionView: View {

    let items: [OnboardingOptionDTO]

    @Binding var selectedItem: OnboardingOptionDTO?

    // MARK: - Properties

    private let metropolitanCodes: Set<String> = [
        "SEOUL",
        "BUSAN",
        "DAEGU",
        "INCHEON",
        "GWANGJU",
        "DAEJEON",
        "ULSAN",
        "SEJONG"
    ]

    private var metropolitanItems: [OnboardingOptionDTO] {
        items.filter { metropolitanCodes.contains($0.value) }
    }

    private var provinceItems: [OnboardingOptionDTO] {
        items.filter { !metropolitanCodes.contains($0.value) }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // MARK: - Metropolitan Cities

            if !metropolitanItems.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    Text("특별·광역시")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.gray)

                    regionGrid(items: metropolitanItems)
                }
            }

            // MARK: - Provinces

            if !provinceItems.isEmpty {
                Rectangle()
                    .fill(Color.gray.opacity(0.12))
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: 14) {
                    Text("도")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.gray)

                    regionGrid(items: provinceItems)
                }
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal, 24)
    }

    // MARK: - Region Grid

    private func regionGrid(items: [OnboardingOptionDTO]) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items, id: \.value) { item in
                Button {
                    selectedItem = item
                } label: {
                    Text(item.label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(
                            selectedItem?.value == item.value
                            ? .white
                            : Color.primary
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            selectedItem?.value == item.value
                            ? Color(red: 0.20, green: 0.39, blue: 0.91)
                            : .white
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedItem?.value == item.value
                                    ? Color.clear
                                    : Color.gray.opacity(0.25),
                                    lineWidth: 1.5
                                )
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
