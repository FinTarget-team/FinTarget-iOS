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
    
    /// 현재 온보딩 단계 정보
    @Published var stepData: OnboardingStepDataDTO?
    
    /// 현재 선택한 답변
    @Published var selectedOption: OnboardingOptionDTO?
    
    /// 완료된 질문과 답변
    @Published var answeredQuestions: [OnboardingAnswer] = []
    
    /// API 요청 진행 여부
    @Published var isLoading: Bool = false
    
    /// 온보딩 완료 여부
    @Published var isCompleted: Bool = false
    
    /// 숫자 입력형 질문의 입력값
    @Published var numberInput: String = ""
    
    /// 에러 메시지
    @Published var errorMessage: String?
    
    
    // MARK: - Properties
    
    /// 온보딩 API 서비스
    private let onboardingService: OnboardingServiceProtocol
    
    /// 앱 세션 및 화면 흐름 관리
    private let sessionManager: SessionManager
    
    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    
    init(onboardingService: OnboardingServiceProtocol = OnboardingService(), sessionManager: SessionManager) {
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
                print("질문: \(response.data.question)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 답변 선택
    /// 온보딩 선택지 선택
    func selectOption(_ option: OnboardingOptionDTO) {
        selectedOption = option
    }
    
    // MARK: - 온보딩 답변 제출
    /// 현재 온보딩 단계의 답변 제출
    func submitAnswer() {
        guard let stepData,
              !isLoading else {
            return
        }
        
        let value: String
        let displayAnswer: String
        
        // CHIP 타입
        if stepData.answerType == "CHIP" {
            guard let selectedOption else { return }
            
            value = selectedOption.value
            displayAnswer = selectedOption.label
        }
        
        // NUMBER 타입
        else if stepData.answerType == "NUMBER" {
            guard !numberInput.isEmpty else { return }
            
            value = numberInput
            displayAnswer = numberInput
        }
        
        // 지원하지 않는 타입
        else {
            return
        }
        
        let request = OnboardingAnswerRequestDTO(
            step: stepData.step,
            value: value
        )
        
        isLoading = true
        errorMessage = nil
        
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
                
                self.answeredQuestions.append(
                    OnboardingAnswer(
                        question: stepData.question,
                        answer: displayAnswer
                    )
                )
                
                // 입력 상태 초기화
                self.selectedOption = nil
                self.numberInput = ""
                
                if response.data.complete {
                    self.isCompleted = true
                    print("온보딩 완료")
                } else {
                    self.stepData = response.data
                    
                    print("온보딩 답변 제출 성공")
                    print("다음 단계: \(response.data.step)")
                    print("다음 질문: \(response.data.question)")
                }
            }
            .store(in: &cancellables)
    }
    
    /// 온보딩 완료 후 메인 화면으로 이동
    func moveToHome() {
        sessionManager.completeOnboarding()
    }
}
