//
//  SimulationMetricCard.swift
//  FinTarget
//
//  Created by 박병선 on 10/28/26.
//
import SwiftUI

struct SimulationMetricCard: View {

    let title: String
    let value: String
    let sub: String

    var valueColor: Color = .primary

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.PretendardMedium(size: 13))
                .foregroundColor(.gray)

            Text(value)
                .font(.PretendardBold(size: 20))
                .foregroundColor(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(sub)
                .font(.PretendardMedium(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
