//
//  PolicyAIChatViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import Foundation
import Combine


// MARK: - PolicyAIChatViewModel

/// 정책 AI 채팅 화면의 상태와 API 호출을 관리하는 ViewModel
final class PolicyAIChatViewModel: ObservableObject {

    // MARK: - Published Properties

    /// 현재 대화의 메시지 목록
    @Published var messages: [AIChatMessage] = []

    /// 현재 대화 ID
    @Published var conversationId: String?

    /// 남은 질문 횟수
    @Published var remainingTurns: Int = 10

    /// AI 답변 로딩 상태
    @Published var isLoading: Bool = false

    /// 대화 삭제 진행 상태
    @Published var isDeleting: Bool = false

    /// API 에러 메시지
    @Published var errorMessage: String?

    /// 현재 입력 중인 질문
    @Published var questionText: String = ""

    // MARK: - 사용자 프로필

    /// 사용자 프로필
    @Published var userProfile: UserProfileDataDTO?

    /// 프로필 조회 로딩 상태
    @Published var isProfileLoading: Bool = false

    /// 사용자 프로필 서비스
    private let userService: UserServiceProtocol
    
    // MARK: - Properties

    /// 현재 질문할 정책 ID
    let policyId: String

    /// 정책 API 서비스
    private let policyService: PolicyServiceProtocol

    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()


    // MARK: - Init

    init(
        policyId: String,
        policyService: PolicyServiceProtocol = PolicyService(),
        userService: UserServiceProtocol = UserService()
    ) {
        self.policyId = policyId
        self.policyService = policyService
        self.userService = userService
    }


    // MARK: - Computed Properties

    /// 현재 대화가 시작되었는지 여부
    var hasConversation: Bool {
        !messages.isEmpty
    }

    /// 질문 전송 가능 여부
    var canSendMessage: Bool {

        let trimmedQuestion = questionText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return !trimmedQuestion.isEmpty
            && trimmedQuestion.count <= 500
            && remainingTurns > 0
            && !isLoading
            && !isDeleting
    }

    /// 현재 입력한 질문의 글자 수
    var questionCount: Int {
        questionText.count
    }


    // MARK: - 정책 AI 질문

    /// 사용자가 입력한 질문을 AI에게 전송
    func sendMessage() {

        let question = questionText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard canSendMessage else {
            return
        }

        sendMessage(question: question)
    }


    /// 추천 질문 또는 직접 입력한 질문 전송
    func sendMessage(question: String) {

        let trimmedQuestion = question.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // 빈 질문 방지
        guard !trimmedQuestion.isEmpty else {
            errorMessage = "질문을 입력해 주세요."
            return
        }

        // 500자 초과 방지
        guard trimmedQuestion.count <= 500 else {
            errorMessage = "질문은 500자 이하로 입력해 주세요."
            return
        }

        // 질문 횟수 제한
        guard remainingTurns > 0 else {
            errorMessage = "질문 횟수를 모두 사용했습니다."
            return
        }

        // 중복 요청 방지
        guard !isLoading && !isDeleting else {
            return
        }

        // 기존 에러 초기화
        errorMessage = nil

        // 로딩 시작
        isLoading = true

        // 사용자 메시지 생성
        let userMessage = AIChatMessage(
            content: trimmedQuestion,
            isUser: true
        )

        // 채팅 목록에 사용자 메시지 추가
        messages.append(userMessage)

        // 입력창 초기화
        questionText = ""

        // API 요청 DTO 생성
        let request = PolicyAIChatRequestDTO(
            question: trimmedQuestion,
            conversationId: conversationId
        )

        // API 호출
        policyService.askPolicyAI(
            policyId: policyId,
            request: request
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in

                guard let self = self else { return }

                self.isLoading = false

                switch completion {

                case .finished:
                    break

                case .failure(let error):

                    print("❌ 정책 AI 질문 실패: \(error)")

                    self.errorMessage = self.errorDescription(
                        for: error
                    )

                    // 요청 실패 시 사용자 메시지 제거
                    self.messages.removeAll {
                        $0.id == userMessage.id
                    }
                }
            },
            receiveValue: { [weak self] response in

                guard let self = self else { return }

                print("✅ 정책 AI 질문 성공")
                print("대화 ID: \(response.data.conversationId)")
                print("남은 질문 횟수: \(response.data.remainingTurns)")

                // 대화 ID 저장
                self.conversationId = response.data.conversationId

                // 남은 질문 횟수 갱신
                self.remainingTurns = response.data.remainingTurns

                // AI 답변 메시지 생성
                let aiMessage = AIChatMessage(
                    content: response.data.answer,
                    isUser: false,
                    sourceLimited: response.data.sourceLimited
                )

                // 채팅 목록에 AI 메시지 추가
                self.messages.append(aiMessage)

            }
        )
        .store(in: &cancellables)
    }
    
    // MARK: - 내 프로필 조회 API

    func getMyProfile() {

        isProfileLoading = true

        userService.getMyProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in

                guard let self = self else { return }

                self.isProfileLoading = false

                if case .failure(let error) = completion {
                    print("❌ AI 채팅 프로필 조회 실패: \(error)")
                }

            } receiveValue: { [weak self] response in

                guard let self = self else { return }

                self.userProfile = response.data

                print("✅ AI 채팅 프로필 조회 성공")
                print("지역: \(response.data.region)")
                print("고용 형태: \(response.data.employmentType ?? "정보 없음")")
                print("소득 구간: \(response.data.incomeBracket ?? "정보 없음")")
            }
            .store(in: &cancellables)
    }


    // MARK: - 정책 AI 대화 삭제 API

    /// 현재 AI 대화 내역 삭제
    func deleteConversation() {

        // 대화 ID가 없다면 로컬 메시지만 초기화
        guard let conversationId = conversationId else {
            resetConversation()
            return
        }

        // 중복 삭제 및 질문 요청 방지
        guard !isDeleting && !isLoading else {
            return
        }

        isDeleting = true
        errorMessage = nil

        policyService.deletePolicyAIChat(
            conversationId: conversationId
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in

                guard let self = self else { return }

                self.isDeleting = false

                switch completion {

                case .finished:
                    break

                case .failure(let error):

                    print("❌ 정책 AI 대화 삭제 실패: \(error)")

                    self.errorMessage = self.errorDescription(
                        for: error
                    )
                }
            },
            receiveValue: { [weak self] _ in

                guard let self = self else { return }

                print("✅ 정책 AI 대화 삭제 성공")

                // 채팅 상태 초기화
                self.resetConversation()
            }
        )
        .store(in: &cancellables)
    }
    
    // MARK: - 채팅 상태 초기화

    /// 현재 대화 상태 초기화
    private func resetConversation() {

        messages.removeAll()

        conversationId = nil

        questionText = ""

        errorMessage = nil

        // 질문 횟수는 서버 정책에 따라 관리
        // 삭제 후 임의로 10회 복구하지 않음
    }


    // MARK: - 에러 메시지 처리

    /// API 에러를 사용자에게 표시할 메시지로 변환
    private func errorDescription(
        for error: APIError
    ) -> String {

        switch error {

        case .unauthorized:
            return "로그인 정보가 만료되었습니다. 다시 로그인해 주세요."

        case .serverError(let code, let message):
            return message.isEmpty
                ? "서버 요청에 실패했습니다. (\(code))"
                : message

        default:
            return "요청 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        }
    }
}
