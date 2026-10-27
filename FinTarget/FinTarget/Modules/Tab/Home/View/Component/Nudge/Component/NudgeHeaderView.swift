//
//  NudgeHeaderView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct NudgeHeaderView: View {
    let unreadCount: Int

    var body: some View {
        HStack {
            Text("읽지 않은 알림")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text("\(unreadCount)개")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}
