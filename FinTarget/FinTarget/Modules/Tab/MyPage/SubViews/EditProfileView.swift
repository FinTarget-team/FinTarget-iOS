//
//  EditProfile.swift
//  FinTarget
//
//  Created by 박병선 on 6/15/26.
//

import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 30) {

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Text("← 뒤로")
                            .foregroundColor(.cyan)
                    }

                    Spacer()

                    Text("내 정보 수정")
                        .font(.PretendardBold(size: 28))

                    Spacer()

                    Button {

                    } label: {
                        Text("저장")
                            .foregroundColor(.cyan)
                    }
                }

                Text("기본 프로필")
                    .font(.PretendardBold(size: 18))

                VStack(alignment: .leading, spacing: 24) {

                    Text("이름")
                    Text("문선영")

                    Text("생년월일")
                    Text("2002. 03. 15")

                    Text("거주지")
                    Text("서울특별시")

                    Text("월 세후 소득")
                    Text("2,330,000")

                    Text("직업 유형")

                    HStack {
                        jobChip("직장인", selected: true)
                        jobChip("프리랜서", selected: false)
                        jobChip("학생", selected: false)
                    }

                    Text("현재 저축액")
                    Text("42,000,000")
                }

                Button {

                } label: {
                    Text("저장하기")
                        .font(.PretendardBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.cyan)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

private func jobChip(
    _ title: String,
    selected: Bool
) -> some View {

    Text(title)
        .font(.PretendardMedium(size: 14))
        .foregroundColor(selected ? .cyan : .black)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .overlay {
            Capsule()
                .stroke(
                    selected ? Color.cyan : Color.gray.opacity(0.3)
                )
        }
}
