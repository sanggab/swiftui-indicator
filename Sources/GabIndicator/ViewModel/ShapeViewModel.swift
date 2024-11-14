//
//  ShapeViewModel.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/14/24.
//

import SwiftUI

final class ShapeViewModel: GabReducer {
    struct State: Equatable {
        init() { }
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    @Published private var state: State = .init()
 
    func action(_ action: Action) {
        print("상갑 logEvent \(#function)")
        switch action {
        case .onAppear:
            print("onAppear")
        }
    }
}

extension ShapeViewModel {
    func callAsFunction<V>(_ keyPath: KeyPath<State, V>) -> V where V : Equatable {
        return self.state[keyPath: keyPath]
    }
    
    private func update<V>(_ keyPath: WritableKeyPath<State, V>, newValue: V) where V : Equatable {
        self.state[keyPath: keyPath] = newValue
    }
}
