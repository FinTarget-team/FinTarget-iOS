//
//  AIChatUserInfoSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

// MARK: - AIUserInfoCard

/// AI 채팅에서 사용자 정보를 표시하는 카드
struct AIUserInfoSection: View {

    // MARK: - Properties

    /// 사용자 프로필 정보
    let userProfile: UserProfileDataDTO?

    /// 카드 접기 가능 여부
    let isCollapsible: Bool

    /// 카드 펼침 상태
    @State private var isExpanded: Bool = true


    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // 카드 헤더
            HStack {

                Text("내 정보 기준으로 답해요")
                    .font(.PretendardBold(size: 15))
                    .foregroundColor(.black)

                Spacer()

                if isCollapsible {

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isExpanded.toggle()
                        }
                    } label: {

                        Image(
                            systemName: isExpanded
                                ? "chevron.up"
                                : "chevron.down"
                        )
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(
                            AIChatStyle.secondaryTextColor
                        )
                    }

                } else {

                    Text("내 정보 기반")
                        .font(.PretendardRegular(size: 11))
                        .foregroundColor(
                            AIChatStyle.secondaryTextColor
                        )
                }
            }

            // 사용자 정보
            if isExpanded {

                VStack(alignment: .leading, spacing: 10) {

                    HStack(spacing: 8) {

                        infoTag(
                            title: "연령대",
                            value: ageLabel(userProfile?.birthYear)
                        )

                        infoTag(
                            title: "소득",
                            value: incomeLabel(userProfile?.incomeBracket)
                        )
                    }

                    HStack(spacing: 8) {

                        infoTag(
                            title: "지역",
                            value: regionText
                        )

                        infoTag(
                            title: "취업",
                            value: employmentTypeText
                        )
                    }
                }
            }
        }
        .padding(18)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 10,
            y: 4
        )
        .onAppear {
            isExpanded = !isCollapsible
        }
    }


    // MARK: - Info Tag

    /// 사용자 정보 태그
    private func infoTag(
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 5) {

            Text(title)
                .foregroundColor(
                    AIChatStyle.secondaryTextColor
                )

            Text(value)
                .foregroundColor(.black)
                .fontWeight(.semibold)
        }
        .font(.PretendardRegular(size: 12))
        .padding(.horizontal, 11)
        .padding(.vertical, 9)
        .background(AIChatStyle.backgroundColor)
        .clipShape(Capsule())
        .fixedSize(horizontal: true, vertical: false)
    }
}


// MARK: - User Profile Formatting

extension AIUserInfoSection {

    // MARK: - 나이 범위 계산

    private func ageLabel(_ birthYear: Int?) -> String {

        guard let birthYear = birthYear else {
            return "정보 없음"
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let currentYear = calendar.component(.year, from: Date())

        guard birthYear > 0,
              birthYear <= currentYear else {
            return "정보 없음"
        }

        let minimumAge = currentYear - birthYear - 1
        let maximumAge = currentYear - birthYear

        return "만 \(minimumAge)~\(maximumAge)세"
    }
    
    // MARK: - 소득 구간 변환
    private func incomeLabel(_ value: String?) -> String {

        switch value {

        case "UNDER_150":
            return "150만원 미만"

        case "150_260":
            return "150~260만원"

        case "260_300":
            return "260~300만원"

        case "300_380":
            return "300~380만원"

        case "380_410":
            return "380~410만원"

        case "OVER_410":
            return "410만원 이상"

        default:
            return "정보 없음"
        }
    }

    /// 거주 지역
    private var regionText: String {

        switch userProfile?.region {

        case "SEOUL":
            return "서울"

        case "GYEONGGI":
            return "경기"

        case "INCHEON":
            return "인천"

        case "BUSAN":
            return "부산"

        case "DAEGU":
            return "대구"

        case "DAEJEON":
            return "대전"

        case "GWANGJU":
            return "광주"

        case "ULSAN":
            return "울산"

        case "SEJONG":
            return "세종"

        case "GANGWON":
            return "강원"

        case "CHUNGBUK":
            return "충북"

        case "CHUNGNAM":
            return "충남"

        case "JEONBUK":
            return "전북"

        case "JEONNAM":
            return "전남"

        case "GYEONGBUK":
            return "경북"

        case "GYEONGNAM":
            return "경남"

        case "JEJU":
            return "제주"

        default:
            return userProfile?.region ?? "정보 없음"
        }
    }

    /// 고용 형태
    private var employmentTypeText: String {

        switch userProfile?.employmentType {

        case "EMPLOYED":
            return "재직 중"

        case "UNEMPLOYED":
            return "구직 중"

        case "STUDENT":
            return "학생"

        case "SELF_EMPLOYED":
            return "자영업"

        default:
            return "정보 없음"
        }
    }
}
