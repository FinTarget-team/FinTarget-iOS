//
//  ScrappedPolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 10/1/26.
import SwiftUI

struct ScrappedPolicyView: View {
    
    @ObservedObject var viewModel: PolicyViewModel
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading {
                Spacer()
                
                ProgressView("스크랩한 정책을 불러오는 중...")
                
                Spacer()
                
            } else if viewModel.myPolicies.isEmpty {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("스크랩한 정책이 없어요")
                        .font(.PretendardBold(size: 18))
                    
                    Text("관심 있는 정책을 스크랩해보세요")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        ForEach(viewModel.myPolicies, id: \.userPolicyId) { userPolicy in
                            
                            Text(userPolicy.policy.name)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationTitle("스크랩한 정책")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.getMyPolicies()
        }
    }
}
