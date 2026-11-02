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

    // MARK: - Properties

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var region: String = ""
    @State private var birthYear: Int?
    @State private var employmentType: String = ""
    @State private var incomeBracket: String = ""
    @State private var housingStatus: String = ""

    @State private var showErrorAlert = false

    private var currentYear: Int {
        Calendar(identifier: .gregorian)
            .component(.year, from: Date())
    }

    private var maximumYear: Int {
        currentYear - 14
    }

    // MARK: - Body

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
                            .onChange(of: name) { _, newValue in
                                if newValue.count > 20 {
                                    name = String(newValue.prefix(20))
                                }
                            }
                    }

                    // MARK: - 이메일
                    VStack(alignment: .leading, spacing: 8) {

                        Text("이메일")
                            .font(.PretendardMedium(size: 15))

                        TextField("이메일을 입력해주세요", text: $email)
                            .font(.PretendardMedium(size: 16))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // MARK: - 출생연도

                    VStack(alignment: .leading, spacing: 12) {

                        Text("출생연도")
                            .font(.PretendardMedium(size: 15))

                        Picker(
                            "출생연도",
                            selection: Binding(
                                get: { birthYear ?? 2002 },
                                set: { birthYear = $0 }
                            )
                        ) {
                            ForEach(1940...maximumYear, id: \.self) { year in
                                Text("\(year, format: .number.grouping(.never))년")
                                    .tag(year)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                        .clipped()
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

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {

                            selectionChip(
                                "150만원 미만",
                                selected: incomeBracket == "UNDER_150"
                            ) {
                                incomeBracket = "UNDER_150"
                            }

                            selectionChip(
                                "150~260만원",
                                selected: incomeBracket == "150_260"
                            ) {
                                incomeBracket = "150_260"
                            }

                            selectionChip(
                                "260~300만원",
                                selected: incomeBracket == "260_300"
                            ) {
                                incomeBracket = "260_300"
                            }

                            selectionChip(
                                "300~380만원",
                                selected: incomeBracket == "300_380"
                            ) {
                                incomeBracket = "300_380"
                            }

                            selectionChip(
                                "380~410만원",
                                selected: incomeBracket == "380_410"
                            ) {
                                incomeBracket = "380_410"
                            }

                            selectionChip(
                                "410만원 이상",
                                selected: incomeBracket == "OVER_410"
                            ) {
                                incomeBracket = "OVER_410"
                            }
                        }
                    }

                    // MARK: - 직업 유형

                    VStack(alignment: .leading, spacing: 12) {

                        Text("직업 유형")
                            .font(.PretendardMedium(size: 15))

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {

                            selectionChip(
                                "직장인",
                                selected: employmentType == "EMPLOYED"
                            ) {
                                employmentType = "EMPLOYED"
                            }

                            selectionChip(
                                "구직중",
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

                    // MARK: - 주택 소유 여부

                    VStack(alignment: .leading, spacing: 12) {

                        Text("주택 소유 여부")
                            .font(.PretendardMedium(size: 15))

                        HStack(spacing: 12) {

                            selectionChip(
                                "무주택",
                                selected: housingStatus == "HOMELESS"
                            ) {
                                housingStatus = "HOMELESS"
                            }

                            selectionChip(
                                "주택 소유",
                                selected: housingStatus == "HOMEOWNER"
                            ) {
                                housingStatus = "HOMEOWNER"
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setInitialProfile()
        }
        .onChange(of: viewModel.isProfileUpdated) { _, isUpdated in
            if isUpdated {
                dismiss()
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
        .alert("프로필 수정 실패", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "잠시 후 다시 시도해주세요.")
        }
    }

    // MARK: - 초기 프로필 설정

    private func setInitialProfile() {

        guard let profile = viewModel.userProfile else {
            return
        }

        name = profile.name ?? ""
        email = profile.email ?? ""
        region = profile.region ?? ""
        birthYear = profile.birthYear
        employmentType = profile.employmentType ?? ""
        incomeBracket = profile.incomeBracket ?? ""
        housingStatus = profile.housingStatus ?? ""
    }

    // MARK: - 프로필 저장

    private func saveProfile() {

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            viewModel.errorMessage = "이름을 입력해주세요."
            return
        }

        viewModel.updateMyProfile(
            name: trimmedName,
            email: email.isEmpty ? nil : email,
            region: region.isEmpty ? nil : region,
            birthYear: birthYear,
            employmentType: employmentType.isEmpty ? nil : employmentType,
            incomeBracket: incomeBracket.isEmpty ? nil : incomeBracket,
            housingStatus: housingStatus.isEmpty ? nil : housingStatus
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
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
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
