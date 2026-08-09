//
//  EditExpenseVIew.swift
//  FinTarget
//
//  Created by 박병선 on 6/15/26.
//
import SwiftUI

struct EditExpenseView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory = "식비"
    @State private var amount = "4500"
    @State private var memo = ""
    @State private var reflectSimulation = true
    
    @State private var expenseDate = Date()
    @State private var showDatePicker = false

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 30) {

                // MARK: Header

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Text("← 뒤로")
                            .foregroundColor(.cyan)
                    }

                    Spacer()

                    Text("지출 내역 수정")
                        .font(.PretendardBold(size: 28))

                    Spacer()

                    Button {

                    } label: {
                        Text("삭제")
                            .foregroundColor(.red)
                    }
                }

                // MARK: 지출 정보

                Text("지출 정보")
                    .font(.PretendardBold(size: 18))

                VStack(alignment: .leading, spacing: 24) {

                    // 항목명

                    VStack(alignment: .leading, spacing: 8) {

                        Text("지출 항목명")
                            .font(.PretendardSemiBold(size: 16))

                        TextField(
                            "항목명",
                            text: .constant("카페")
                        )
                    }

                    // 금액

                    VStack(alignment: .leading, spacing: 8) {

                        Text("금액")
                            .font(.PretendardSemiBold(size: 16))

                        HStack {

                            TextField(
                                "금액",
                                text: $amount
                            )
                            .keyboardType(.numberPad)

                            Spacer()

                            Text("원")
                        }
                    }

                    // 날짜
                    VStack(alignment: .leading, spacing: 8) {
                        Text("날짜")
                            .font(.PretendardSemiBold(size: 16))

                        Button {
                            showDatePicker.toggle()
                        } label: {
                            HStack {
                                Text(
                                    expenseDate.formatted(
                                        .dateTime
                                            .year()
                                            .month(.twoDigits)
                                            .day(.twoDigits)
                                    )
                                )

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.cyan)
                            }
                            .foregroundColor(.black)
                        }

                        if showDatePicker {

                            DatePicker(
                                "",
                                selection: $expenseDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                        }
                    }

                    // 카테고리

                    VStack(alignment: .leading, spacing: 12) {

                        Text("카테고리")
                            .font(.PretendardSemiBold(size: 16))

                        HStack(spacing: 12) {

                            categoryChip("식비")
                            categoryChip("교통")
                            categoryChip("쇼핑")
                            categoryChip("문화")
                            categoryChip("기타")
                        }
                    }

                    // 메모

                    VStack(alignment: .leading, spacing: 8) {

                        Text("메모")
                            .font(.PretendardSemiBold(size: 16))

                        TextField(
                            "메모를 입력하세요",
                            text: $memo
                        )
                        .padding(.vertical, 12)
                    }
                }

                Divider()

                // MARK: 시뮬레이션 반영
                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text("시뮬레이션 반영")
                            .font(.PretendardBold(size: 18))

                        Text("수정 시 자산 계획에 즉시 반영됩니다")
                            .font(.PretendardMedium(size: 13))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Toggle("", isOn: $reflectSimulation)
                        .labelsHidden()
                        .tint(.cyan)
                }

                // MARK: 완료 버튼

                Button {

                } label: {

                    Text("수정 완료")
                        .font(.PretendardBold(size: 20))
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
        .toolbar(.hidden, for: .navigationBar)
    }

    private func categoryChip(
        _ title: String
    ) -> some View {

        Button {

            selectedCategory = title

        } label: {

            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(
                    selectedCategory == title
                    ? .cyan
                    : .black
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .overlay {

                    Capsule()
                        .stroke(
                            selectedCategory == title
                            ? Color.cyan
                            : Color.clear
                        )
                }
        }
    }
}
