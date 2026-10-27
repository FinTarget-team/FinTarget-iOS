//
//  HomeViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//  구현해야할 API : 목표(생성,조회), 지출(조회,동기화)
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published(공통)
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Published(유저)
    @Published var userName: String = ""
    
    // MARK: - Published(넛지)
    @Published var nudges: [NudgeDTO] = [] /// 넛지 알림 목록
    @Published var unreadCount: Int = 0 /// 읽지 않은 알림 개수
    
    // MARK: - Published(목표)
    @Published var goal: GoalDataDTO? /// 현재 사용자의 목표
    @Published var hasGoal: Bool = false /// 목표 존재 여부
    
    // MARK: - Published(지출)
    @Published var expenses: [ExpenseDTO] = [] /// 사용자의 지출 내역
    @Published var expenseStats: ExpenseStatsDataDTO? /// 기간별 카테고리 지출 통계

    // MARK: - Dependencies
    private let nudgeService: NudgeServiceProtocol
    private let goalService: GoalServiceProtocol
    private let userService: UserServiceProtocol
    private let expenseService: ExpenseServiceProtocol

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(
        nudgeService: NudgeServiceProtocol = NudgeService(),
        goalService: GoalServiceProtocol = GoalService(),
        userService: UserServiceProtocol = UserService(),
        expenseService: ExpenseServiceProtocol = ExpenseService()
        
    ) {
        self.nudgeService = nudgeService
        self.goalService = goalService
        self.userService = userService
        self.expenseService = expenseService
    }
    
    // MARK: - 홈 데이터 조회
    /// 홈 화면에 필요한 데이터를 조회(로컬)
    func fetchHomeData() {
        fetchProfile()
        fetchGoal()
        fetchNudges()
        fetchCurrentMonthExpenseStats()
    }

    // MARK: - 넛지 목록 조회
    /// 사용자의 넛지 알림 목록 조회 api
    func fetchNudges() {
        isLoading = true
        errorMessage = nil

        nudgeService.getNudges()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    self.isLoading = false

                    if case let .failure(error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("넛지 목록 조회 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    self.nudges = response.data.nudges
                    self.unreadCount = response.data.unreadCount

                    print("넛지 목록 조회 성공")
                    print("넛지 개수: \(response.data.nudges.count)")
                    print("읽지 않은 넛지 개수: \(response.data.unreadCount)")
                }
            )
            .store(in: &cancellables)
    }
    
    
    // MARK: - 넛지 삭제
    func deleteNudge(nudgeId: String) {
        nudgeService.deleteNudge(nudgeId: nudgeId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 넛지 삭제 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }

                    self.nudges.removeAll {
                        $0.nudgeId == nudgeId
                    }

                    print("✅ 넛지 삭제 성공")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 넛지 읽음 처리
    func readNudge(nudgeId: String) {
        nudgeService.readNudge(nudgeId: nudgeId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ 넛지 읽음 처리 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    
                    print("✅ 넛지 읽음 처리 성공: \(nudgeId)")
                    
                    self.fetchNudges()
                }
            )
            .store(in: &cancellables)
    }
    // MARK: - 프로필 조회
    /// 현재 로그인한 사용자의 프로필 조회 api
    private func fetchProfile() {
        userService.getMyProfile()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    // self.userName = response.data.name ?? "사용자" -> 옵셔널로 하는 게 마자??
                    
                    self.userName = response.data.name ?? "사용자"
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 목표 조회
    /// 사용자가 등록해놨었던 목표 조회 api
    private func fetchGoal() {
        isLoading = true
        goalService.getGoal()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 목표 조회 실패: \(error)")}
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.goal = response.data
                if let goal = response.data {
                    print("🎯 목표 조회 성공")
                    print("목표: \(goal.title)")
                    print("목표 금액: \(goal.targetAmount)")
                    print("현재 금액: \(goal.currentAmount)")
                    print("진행률: \(goal.progressRate)%")
                } else {
                    print("📭 등록된 목표 없음")}
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 목표 생성
    /// 새로운 목표생성api
    func createGoal(
        title: String,
        targetAmount: Int,
        currentAmount: Int,
        deadline: String
    ) {
        let request = CreateGoalRequestDTO(
            title: title,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline
        )

        isLoading = true

        goalService.createGoal(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 목표 생성 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                self.goal = response.data

                print("✅ 목표 생성 성공")
                print("목표: \(response.data.title)")
                print("목표 금액: \(response.data.targetAmount)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 전체 지출 내역 조회
    /// 사용자의 전체 지출 내역 조회 api
    func fetchExpenses() {
        isLoading = true
        errorMessage = nil
        
        expenseService.getExpenses()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 전체 지출 내역 조회 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    self.expenses = response.data
                    
                    print("✅ 전체 지출 내역 조회 성공")
                    print("지출 내역 개수: \(response.data.count)")
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 기간별 지출 내역 조회
    /// 설정한 기간의 지출 내역 조회 api
    func fetchExpensesByPeriod(start: String, end: String) {
        isLoading = true
        errorMessage = nil
        
        expenseService.getExpensesByPeriod(start: start, end: end)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 기간별 지출 내역 조회 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    self.expenses = response.data
                    
                    print("✅ 기간별 지출 내역 조회 성공")
                    print("조회 기간: \(start) ~ \(end)")
                    print("지출 내역 개수: \(response.data.count)")
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 기간별 카테고리 통계 조회
    /// 설정한 기간의 카테고리별 지출 통계 조회 api
    func fetchExpenseStats(start: String, end: String) {
        isLoading = true
        errorMessage = nil
        
        expenseService.getExpenseStats(start: start, end: end)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 카테고리별 지출 통계 조회 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    self.expenseStats = response.data
                    
                    print("✅ 카테고리별 지출 통계 조회 성공")
                    print("전체 지출 금액: \(response.data.totalAmount)")
                    
                    response.data.byCategory.forEach { category in
                        print("\(category.category): \(category.amount)원")
                    }
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 지출 내역 동기화
    /// 사용자의 지출 내역 동기화 api
    func syncExpenses(request: [ExpenseSyncRequestDTO]) {
        isLoading = true
        errorMessage = nil
        
        expenseService.syncExpenses(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 지출 내역 동기화 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    print("✅ 지출 내역 동기화 성공")
                    print("응답 메시지: \(response.message)")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 이번 달 지출 통계 조회(홈전용)
    /// 현재 날짜를 기준으로 이번 달의 지출 통계 조회
    func fetchCurrentMonthExpenseStats() {
        let calendar = Calendar.current
        let now = Date()
        
        guard let interval = calendar.dateInterval(of: .month, for: now) else {
            return
        }
        
        let startDate = interval.start
        let endDate = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        
        fetchExpenseStats(
            start: start,
            end: end
        )
    }
}

