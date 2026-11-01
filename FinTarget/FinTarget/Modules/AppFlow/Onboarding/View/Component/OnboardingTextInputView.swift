//
//  OnboardingTextInputView.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

struct OnboardingTextInputView: View {

    @Binding var text: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - TextField

            TextField("이름을 입력해 주세요", text: $text)
                .textContentType(.nickname)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 17))
                .padding(.horizontal, 20)
                .frame(height: 58)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onChange(of: text) { _, newValue in
                    if newValue.count > 20 {
                        text = String(newValue.prefix(20))
                    }
                }

            // MARK: - Character Count

            HStack {
                Text("사용하실 이름을 입력해 주세요.")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)

                Spacer()

                Text("\(text.count)/20")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 24)
    }
}
