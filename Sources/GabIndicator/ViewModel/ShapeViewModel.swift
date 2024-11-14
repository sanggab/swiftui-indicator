//
//  ShapeViewModel.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/14/24.
//

import SwiftUI

final class ShapeViewModel: GabReducer, ShapeMainFeatures {
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

extension ShapeViewModel {
    @usableFromInline
    func makeMovePoint(in rect: CGRect, radians: Double) -> RefreshShapeMovePoint {
        let x = (rect.width / 2) + ((rect.width / 2) * cos(radians))
        let y = (rect.height / 2) + ((rect.height / 2) * sin(radians))
        
        return RefreshShapeMovePoint(x: x,
                                     y: y)
    }
    @usableFromInline
    func makeAddLinePoint(in rect: CGRect, radians: Double) -> RefreshShapeAddLinePoint {
        let movePoint = self.makeMovePoint(in: rect, radians: radians)
        
        let x = movePoint.x + ((rect.width / 2) * cos(radians))
        let y = movePoint.y + ((rect.height / 2) * sin(radians))
        
        return RefreshShapeAddLinePoint(x: x,
                                        y: y)
    }
    @usableFromInline
    func makeAddLinePoint(in rect: CGRect, radians: Double, movePoint: RefreshShapeMovePoint) -> RefreshShapeAddLinePoint {
        let x = movePoint.x + ((rect.width / 2) * cos(radians))
        let y = movePoint.y + ((rect.height / 2) * sin(radians))
        
        return RefreshShapeAddLinePoint(x: x,
                                        y: y)
    }
    @usableFromInline
    func makeShapePoints(in rect: CGRect, radians: Double) -> ShapeMainFeatures.ShapePoints {
        let movePoint = self.makeMovePoint(in: rect, radians: radians)
        let addLinePoint = self.makeAddLinePoint(in: rect, radians: radians, movePoint: movePoint)
        
        return (movePoint, addLinePoint)
    }
}
