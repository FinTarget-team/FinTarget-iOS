//
//  TabBarVisibilityKey.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

// MARK: - TabBar Visibility Key

private struct TabBarVisibilityKey: EnvironmentKey {

    static let defaultValue: Binding<Bool> = .constant(false)
}

// MARK: - EnvironmentValues

extension EnvironmentValues {

    var isTabBarHidden: Binding<Bool> {

        get {
            self[TabBarVisibilityKey.self]
        }

        set {
            self[TabBarVisibilityKey.self] = newValue
        }
    }
}
