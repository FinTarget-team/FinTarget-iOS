//
//  OnboardingViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
//
import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {


    // MARK: - Published Properties
    @Published var stepData: OnboardingStepDataDTO? /// 현재 온보딩 단계 정보
    @Published var selectedOption: OnboardingOptionDTO? /// 현재 선택한 답변
    @Published var answeredQuestions: [OnboardingAnswer] = [] /// 완료된 질문과 답변
    @Published var isLoading: Bool = false /// API 요청 진행 여부
    @Published var isCompleted: Bool = false /// 온보딩 완료 여부
    @Published var numberInput: String = "" /// 숫자 입력형 질문의 입력값
    @Published var textInput: String = "" /// 텍스트 입력형 질문의 입력값
    @Published var errorMessage: String? /// 에러 메시지

    // MARK: - Properties

    /// 온보딩 API 서비스
    private let onboardingService: OnboardingServiceProtocol

    /// 앱 세션 및 화면 흐름 관리
    private let sessionManager: SessionManager

    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        onboardingService: OnboardingServiceProtocol = OnboardingService(),
        sessionManager: SessionManager
    ) {
        self.onboardingService = onboardingService
        self.sessionManager = sessionManager
    }

    // MARK: - 온보딩 단계 조회

    /// 현재 온보딩 단계 조회
    func fetchStep(step: Int = 1) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        onboardingService.getStep(step: step)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("온보딩 단계 조회 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                self.stepData = response.data
                self.isCompleted = response.data.complete

                print("온보딩 단계 조회 성공")
                print("현재 단계: \(response.data.step)")
                print("전체 단계: \(response.data.totalSteps)")
                print("질문: \(response.data.question)")
                print("답변 타입: \(response.data.answerType)")
            }
            .store(in: &cancellables)
    }

    // MARK: - 답변 선택

    /// 온보딩 선택지 선택
    func selectOption(_ option: OnboardingOptionDTO) {
        selectedOption = option
    }

    // MARK: - 입력값 초기화

    /// 다음 단계로 이동할 때 이전 입력값 초기화
    private func resetInput() {
        selectedOption = nil
        numberInput = ""
        textInput = ""
    }

    // MARK: - 입력값 검증

    /// 현재 단계의 입력값 검증
    private func validateInput(
        step: Int,
        answerType: String,
        value: String
    ) -> Bool {

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)

        // MARK: - TEXT 타입

        if answerType == "TEXT" {
            guard !trimmedValue.isEmpty else {
                errorMessage = "이름을 입력해 주세요."
                return false
            }

            guard trimmedValue.count <= 20 else {
                errorMessage = "이름은 최대 20자까지 입력할 수 있습니다."
                return false
            }

            return true
        }

        // MARK: - NUMBER 타입

        if answerType == "NUMBER" {
            guard !trimmedValue.isEmpty else {
                errorMessage = "값을 입력해 주세요."
                return false
            }

            guard trimmedValue.allSatisfy({ $0.isNumber }) else {
                errorMessage = "숫자만 입력해 주세요."
                return false
            }

            // 2단계: 출생연도
            if step == 2 {
                guard trimmedValue.count == 4,
                      let birthYear = Int(trimmedValue) else {
                    errorMessage = "출생연도는 4자리 숫자로 입력해 주세요."
                    return false
                }

                let currentYear = Calendar(identifier: .gregorian)
                    .component(.year, from: Date())

                guard birthYear >= 1940,
                      birthYear <= currentYear - 14 else {
                    errorMessage = "올바른 출생연도를 입력해 주세요."
                    return false
                }
            }

            // 7단계: 목표 금액
            if step == 7 {
                guard let amount = Int(trimmedValue),
                      amount >= 100_000,
                      amount <= 5_000_000_000 else {
                    errorMessage = "목표 금액은 10만 원 이상 50억 원 이하로 입력해 주세요."
                    return false
                }
            }

            return true
        }

        // MARK: - CHIP 타입

        if answerType == "CHIP" {
            guard selectedOption != nil else {
                errorMessage = "항목을 선택해 주세요."
                return false
            }

            return true
        }

        errorMessage = "지원하지 않는 입력 방식입니다."
        return false
    }

    // MARK: - 온보딩 답변 제출

    /// 현재 온보딩 단계의 답변 제출
    func submitAnswer() {
        guard let stepData, !isLoading else { return }

        let value: String
        let displayAnswer: String

        // MARK: - CHIP 타입

        if stepData.answerType == "CHIP" {
            guard let selectedOption else {
                errorMessage = "항목을 선택해 주세요."
                return
            }

            value = selectedOption.value
            displayAnswer = selectedOption.label
        }

        // MARK: - NUMBER 타입

        else if stepData.answerType == "NUMBER" {
            value = numberInput.trimmingCharacters(in: .whitespacesAndNewlines)
            displayAnswer = value
        }

        // MARK: - TEXT 타입

        else if stepData.answerType == "TEXT" {
            value = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
            displayAnswer = value
        }

        // MARK: - 지원하지 않는 타입

        else {
            errorMessage = "지원하지 않는 입력 방식입니다."
            return
        }

        // MARK: - 입력값 검증

        guard validateInput(
            step: stepData.step,
            answerType: stepData.answerType,
            value: value
        ) else {
            return
        }

        // MARK: - Request DTO 생성

        let request = OnboardingAnswerRequestDTO(
            step: stepData.step,
            value: value
        )

        isLoading = true
        errorMessage = nil

        // MARK: - API 요청

        onboardingService.submitAnswer(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("온보딩 답변 제출 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                // 완료된 질문과 답변 저장
                self.answeredQuestions.append(
                    OnboardingAnswer(
                        question: stepData.question,
                        answer: displayAnswer
                    )
                )

                // 입력 상태 초기화
                self.resetInput()

                // MARK: - 온보딩 완료

                if response.data.complete {
                    self.stepData = response.data
                    self.isCompleted = true

                    print("온보딩 완료")
                } else {
                    // 다음 단계 정보 저장
                    self.stepData = response.data

                    print("온보딩 답변 제출 성공")
                    print("다음 단계: \(response.data.step)")
                    print("다음 질문: \(response.data.question)")
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - 온보딩 완료 후 화면 이동

    /// 온보딩 완료 후 메인 화면으로 이동
    func moveToHome() {
        guard isCompleted else { return }
        sessionManager.completeOnboarding()
    }
}
