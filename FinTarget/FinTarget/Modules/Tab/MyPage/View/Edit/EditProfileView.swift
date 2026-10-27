//
//  EditProfile.swift
//  FinTarget
//
//  Created by 박병선 on 6/15/26.
//
import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MyPageViewModel

    @State private var name: String = ""
    @State private var region: String = ""
    @State private var ageGroup: String = ""
    @State private var employmentType: String = ""
    @State private var incomeBracket: String = ""

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 30) {

                // MARK: - Header

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
                        saveProfile()
                    } label: {
                        Text("저장")
                            .foregroundColor(.cyan)
                    }
                    .disabled(viewModel.isLoading)
                }

                // MARK: - 기본 프로필

                Text("기본 프로필")
                    .font(.PretendardBold(size: 18))

                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - 이름

                    VStack(alignment: .leading, spacing: 8) {

                        Text("이름")
                            .font(.PretendardMedium(size: 15))

                        TextField("이름을 입력해주세요", text: $name)
                            .font(.PretendardMedium(size: 16))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // MARK: - 연령대

                    VStack(alignment: .leading, spacing: 12) {

                        Text("연령대")
                            .font(.PretendardMedium(size: 15))

                        HStack {
                            selectionChip(
                                "청년",
                                selected: ageGroup == "YOUTH"
                            ) {
                                ageGroup = "YOUTH"
                            }

                            selectionChip(
                                "중장년",
                                selected: ageGroup == "MIDDLE"
                            ) {
                                ageGroup = "MIDDLE"
                            }
                        }
                    }

                    // MARK: - 거주지

                    VStack(alignment: .leading, spacing: 8) {

                        Text("거주지")
                            .font(.PretendardMedium(size: 15))

                        TextField("거주지를 입력해주세요", text: $region)
                            .font(.PretendardMedium(size: 16))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // MARK: - 월 소득

                    VStack(alignment: .leading, spacing: 12) {

                        Text("월 소득")
                            .font(.PretendardMedium(size: 15))

                        HStack {
                            selectionChip(
                                "200만원 미만",
                                selected: incomeBracket == "UNDER_2M"
                            ) {
                                incomeBracket = "UNDER_2M"
                            }

                            selectionChip(
                                "200~300만원",
                                selected: incomeBracket == "200_300"
                            ) {
                                incomeBracket = "200_300"
                            }

                            selectionChip(
                                "300만원 이상",
                                selected: incomeBracket == "OVER_3M"
                            ) {
                                incomeBracket = "OVER_3M"
                            }
                        }
                    }

                    // MARK: - 직업 유형

                    VStack(alignment: .leading, spacing: 12) {

                        Text("직업 유형")
                            .font(.PretendardMedium(size: 15))

                        HStack {
                            selectionChip(
                                "직장인",
                                selected: employmentType == "EMPLOYED"
                            ) {
                                employmentType = "EMPLOYED"
                            }

                            selectionChip(
                                "무직",
                                selected: employmentType == "UNEMPLOYED"
                            ) {
                                employmentType = "UNEMPLOYED"
                            }

                            selectionChip(
                                "학생",
                                selected: employmentType == "STUDENT"
                            ) {
                                employmentType = "STUDENT"
                            }

                            selectionChip(
                                "자영업자",
                                selected: employmentType == "SELF_EMPLOYED"
                            ) {
                                employmentType = "SELF_EMPLOYED"
                            }
                        }
                    }
                }

                // MARK: - 저장하기

                Button {
                    saveProfile()
                } label: {

                    if viewModel.isLoading {

                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)

                    } else {

                        Text("저장하기")
                            .font(.PretendardBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                }
                .background(Color.cyan)
                .cornerRadius(12)
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            setInitialProfile()
        }
        .onChange(of: viewModel.isProfileUpdated) { _, isUpdated in
            if isUpdated {
                dismiss()
            }
        }
    }

    // MARK: - 초기 프로필 설정

    private func setInitialProfile() {
        name = viewModel.userProfile?.name ?? ""
        region = viewModel.userProfile?.region ?? ""
        ageGroup = viewModel.userProfile?.ageGroup ?? ""
        employmentType = viewModel.userProfile?.employmentType ?? ""
        incomeBracket = viewModel.userProfile?.incomeBracket ?? ""
    }

    // MARK: - 프로필 저장

    private func saveProfile() {
        viewModel.updateMyProfile(
            name: name,
            region: region,
            ageGroup: ageGroup,
            employmentType: employmentType,
            incomeBracket: incomeBracket
        )
    }

    // MARK: - 선택 Chip

    private func selectionChip(
        _ title: String,
        selected: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button {
            action()
        } label: {
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
        .buttonStyle(.plain)
    }
}
