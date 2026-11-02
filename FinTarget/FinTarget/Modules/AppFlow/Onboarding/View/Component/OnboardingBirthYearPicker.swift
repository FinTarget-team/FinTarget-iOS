//
//  OnboardingBirthYearPicker.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

struct OnboardingBirthYearPicker: View {

    @Binding var selectedYear: Int

    // MARK: - Properties

    private var currentYear: Int {
        Calendar(identifier: .gregorian)
            .component(.year, from: Date())
    }

    private var maximumYear: Int {
        currentYear - 14
    }

    private var years: [Int] {
        Array(1940...maximumYear)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // MARK: - Header

            HStack {
                Text("출생연도")
                    .font(.system(size: 20, weight: .bold))

                Spacer()

                Text("만 나이로 계산해요")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
            }

            // MARK: - Year Picker

            Picker("출생연도", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(year, format: .number.grouping(.never))년")
                        .font(.system(size: 22))
                        .tag(year)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 220)
            .clipped()
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32
            )
        )
    }
}
