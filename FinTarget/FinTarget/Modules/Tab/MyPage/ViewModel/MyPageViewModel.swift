//
//  MyPageViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//  연결해야하는 API: 회원(조회,수정,탈퇴), 로그아웃, 목표수정
import Foundation
import Combine

@MainActor
final class MyPageViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userProfile: UserProfileDataDTO? /// 사용자 정보
    @Published var goal: GoalDataDTO? /// 목표 정보
    

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    /// 프로필 수정 성공 여부
    @Published var isProfileUpdated: Bool = false
    
    /// 회원탈퇴 성공 여부
    @Published var isWithdrawn: Bool = false
    
    
    // MARK: - Properties
    private let userService: UserServiceProtocol /// 사용자 API 서비스
    private let authService: AuthServiceProtocol /// 인증 API 서비스
    private let goalService: GoalServiceProtocol /// 목표 API 서비스
    private let sessionManager: SessionManager /// 사용자 세션 관리
    
    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    init(
        userService: UserServiceProtocol = UserService(),
        authService: AuthServiceProtocol = AuthService(),
        goalService: GoalServiceProtocol = GoalService(),
        sessionManager: SessionManager
    ) {
        self.userService = userService
        self.authService = authService
        self.goalService = goalService
        self.sessionManager = sessionManager
    }
    // MARK: - 내 프로필 조회 API
    func getMyProfile() {
        isLoading = true
        errorMessage = nil
        
        userService.getMyProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 프로필 조회 실패: \(error)")
                }
                
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.userProfile = response.data
                
                print("✅ 프로필 조회 성공")
                print("이름: \(response.data.name)")
                print("이메일: \(response.data.email)")
                print("지역: \(response.data.region)")
                print("Provider: \(response.data.provider)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 프로필 수정 API
    func updateMyProfile(
        name: String? = nil,
        region: String? = nil,
        ageGroup: String? = nil,
        employmentType: String? = nil,
        incomeBracket: String? = nil
    ) {
        isLoading = true
        errorMessage = nil
        isProfileUpdated = false
        
        let request = UpdateUserProfileRequestDTO(
            name: name,
            region: region,
            ageGroup: ageGroup,
            employmentType: employmentType,
            incomeBracket: incomeBracket
        )
        
        userService.updateMyProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 프로필 수정 실패: \(error)")
                }
                
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.userProfile = response.data
                self.isProfileUpdated = true
                
                print("✅ 프로필 수정 성공")
                print("이름: \(response.data.name)")
                print("지역: \(response.data.region)")
                print("연령대: \(response.data.ageGroup)")
                print("직업 유형: \(response.data.employmentType)")
                print("소득 구간: \(response.data.incomeBracket)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 로그아웃 API
    func logout() {
        isLoading = true
        errorMessage = nil
        authService.logout()

            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 로그아웃 실패: \(error)")
                }
            } receiveValue: { [weak self] response in

                guard let self = self else { return }

                print("✅ 로그아웃 성공")
                print("Message: \(response.message)")

                self.sessionManager.logout()

            }
            .store(in: &cancellables)
    }
    
    // MARK: - 회원탈퇴 API
    func withdraw() {
        isLoading = true
        errorMessage = nil
        isWithdrawn = false
        
        userService.withdraw()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 회원탈퇴 실패: \(error)")
                }
                
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.isWithdrawn = true
                
                print("✅ 회원탈퇴 성공")
                print("Message: \(response.message)")
                
                self.sessionManager.logout() /// 로컬 세션 삭제 후 LoginView 이동
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 목표 수정
    /// 사용자의 목표 수정 api
    func updateGoal(
        title: String,
        targetAmount: Int,
        currentAmount: Int,
        deadline: String
    ) {
        isLoading = true
        errorMessage = nil
        
        let request = UpdateGoalRequestDTO(
            title: title,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline
        )
        
        goalService.updateGoal(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 목표 수정 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    self.goal = response.data
                    
                    print("✅ 목표 수정 성공")
                    print("수정된 목표: \(response.data.title)")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 목표 삭제
    /// 사용자의 목표 삭제 api
    func deleteGoal() {
        isLoading = true
        errorMessage = nil
        
        goalService.deleteGoal()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("❌ 목표 삭제 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    self.goal = nil
                    
                    print("✅ 목표 삭제 성공")
                    print("응답 메시지: \(response.message)")
                }
            )
            .store(in: &cancellables)
    }
}
