//
//  UserProfileFormatter.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import Foundation

// MARK: - 사용자 프로필 공통 포맷터
/// 출생연도, 월 소득, 직업 유형의 서버값 (영어)-> 프론트(한글)로 매핑

enum UserProfileFormatter {

    // MARK: - 출생연도

    static func birthYear(_ value: Int?) -> String {
        guard let value else {
            return "-"
        }

        return "\(value)년"
    }

    // MARK: - 나이 범위

    static func ageRange(_ birthYear: Int?) -> String {

        guard let birthYear else {
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

    // MARK: - 직업 유형

    static func employmentType(_ value: String?) -> String {

        switch value {
        case "EMPLOYED":
            return "직장인"

        case "UNEMPLOYED":
            return "구직중"

        case "STUDENT":
            return "학생"

        case "SELF_EMPLOYED":
            return "자영업자"

        default:
            return "-"
        }
    }

    // MARK: - 월 소득

    static func incomeBracket(_ value: String?) -> String {

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
            return "-"
        }
    }

    // MARK: - 거주 지역

    static func region(_ value: String?) -> String {

        switch value {
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
            return "-"
        }
    }

    // MARK: - 주택 소유 여부

    static func housingStatus(_ value: String?) -> String {

        switch value {
        case "HOMELESS":
            return "무주택"

        case "HOMEOWNER":
            return "주택 소유"

        default:
            return "-"
        }
    }
}
