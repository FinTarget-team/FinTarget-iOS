//
//  NudgeEmptyView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct NudgeEmptyView: View {

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bell.slash")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("아직 알림이 없어요")
                .font(.headline)

            Text("새로운 알림이 생기면\n여기에서 확인할 수 있어요.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    NudgeEmptyView()
}
