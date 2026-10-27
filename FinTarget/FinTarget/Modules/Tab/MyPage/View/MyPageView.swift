//
//  MyPageView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct MyPageView: View {
    
    @StateObject private var viewModel: MyPageViewModel
    @State private var showWithdrawAlert = false
    
    init(sessionManager: SessionManager) {
        _viewModel = StateObject(
            wrappedValue: MyPageViewModel(
                sessionManager: sessionManager
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    profile
                    myInfo
                    currentGoal
                    accountButtons
                }
                .padding(20)
            }
            .background(Color(.systemBackground))
            .onAppear {
                viewModel.getMyProfile()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("마이페이지")
                .font(.PretendardBold(size: 32))
            
            Spacer()
        }
    }

    // MARK: - Profile
    private var profile: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.cyan)
                .frame(width: 70, height: 70)
                .overlay {
                    Text(profileInitial)
                        .font(.PretendardBold(size: 32))
                        .foregroundColor(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.userProfile?.name ?? "사용자")
                    .font(.PretendardBold(size: 24))

                Text(profileDescription)
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                Text("편집")
                    .font(.PretendardMedium(size: 15))
                    .foregroundColor(.cyan)
                    .frame(width: 60, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cyan)
                    }
            }
        }
    }

    // MARK: - 내 정보
    private var myInfo: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("내 정보")
                .font(.PretendardBold(size: 20))
            
            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                infoRow(
                    "연령대",
                    ageGroupDisplayName(viewModel.userProfile?.ageGroup)
                )
            }
            
            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                infoRow(
                    "거주지",
                    viewModel.userProfile?.region ?? "-"
                )
            }
            
            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                infoRow(
                    "월 소득",
                    incomeBracketDisplayName(viewModel.userProfile?.incomeBracket)
                )
            }
            
            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                infoRow(
                    "직업 유형",
                    employmentTypeDisplayName(viewModel.userProfile?.employmentType)
                )
            }
        }
    }

    // MARK: - 현재 목표
    private var currentGoal: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("현재 목표")
                    .font(.PretendardBold(size: 20))

                Spacer()

                NavigationLink {
                    EditGoalView(viewModel: viewModel)
                } label: {
                    Text("수정")
                        .font(.PretendardRegular(size: 18))
                        .foregroundColor(.cyan)
                }
            }

            Text("전세 자금 1억")
                .font(.PretendardBold(size: 18))

            ProgressView(value: 0.42)
                .tint(.cyan)

            HStack {
                Text("현재 4,200만원 (42%)")
                
                Spacer()
                
                Text("D-287일")
            }
            .font(.PretendardMedium(size: 14))
            .foregroundColor(.gray)
        }
    }

    // MARK: - 로그아웃 / 회원탈퇴
    private var accountButtons: some View {
        VStack(spacing: 16) {
            
            Button {
                viewModel.logout()
            } label: {
                Text("로그아웃")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                showWithdrawAlert = true
            } label: {
                Text("회원탈퇴")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.red)
            }
            .padding(.top, 4)
            /// 탈퇴 확인 메세지
            .alert("회원탈퇴", isPresented: $showWithdrawAlert) {
                Button("취소", role: .cancel) { }
                Button("탈퇴", role: .destructive) {
                    viewModel.withdraw()
                }
            } message: {
                Text("회원탈퇴 시 저장된 정보가 삭제됩니다.\n정말 탈퇴하시겠어요?")
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    // MARK: - Profile Helpers
    private var profileInitial: String {
        guard let name = viewModel.userProfile?.name,
              let firstCharacter = name.first else {
            return "?"
        }
        
        return String(firstCharacter)
    }

    private var profileDescription: String {
        let region = viewModel.userProfile?.region ?? "-"
        
        return region
    }

    // MARK: - Row Builders
    private func infoRow(
        _ title: String,
        _ value: String
    ) -> some View {
        HStack {
            Text(title)
                .font(.PretendardMedium(size: 16))

            Spacer()

            HStack(spacing: 4) {
                Text(value)
                    .font(.PretendardSemiBold(size: 16))

                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }
        }
        .foregroundStyle(.primary)
        .contentShape(Rectangle())
    }
    
    // MARK: - Display Helpers

    /// 연령대 한글 변환
    private func ageGroupDisplayName(_ value: String?) -> String {
        switch value {
        case "YOUTH":
            return "청년"
        case "MIDDLE":
            return "중장년"
        default:
            return "-"
        }
    }

    /// 직업 유형 한글 변환
    private func employmentTypeDisplayName(_ value: String?) -> String {
        switch value {
        case "EMPLOYED":
            return "직장인"
        case "UNEMPLOYED":
            return "무직"
        case "STUDENT":
            return "학생"
        case "SELF_EMPLOYED":
            return "자영업자"
        default:
            return "-"
        }
    }

    /// 월 소득 한글 변환
    private func incomeBracketDisplayName(_ value: String?) -> String {
        switch value {
        case "UNDER_2M":
            return "200만원 미만"
        case "200_300":
            return "200~300만원"
        case "OVER_3M":
            return "300만원 이상"
        default:
            return "-"
        }
    }
}

