//
//  Reducer.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/14/24.
//

import SwiftUI

protocol GabReducer: ObservableObject {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    func callAsFunction<V: Equatable>(_ keyPath: KeyPath<State, V>) -> V
    
    func action(_ action: Action)
}
