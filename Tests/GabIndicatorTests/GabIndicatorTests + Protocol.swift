//
//  GabIndicatorTests + Protocol.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI

protocol TestGabReducer: ObservableObject {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    func callAsFunction<V: Equatable>(_ keyPath: KeyPath<State, V>) -> V
    
    func action(_ action: Action)
}

public protocol TestShapePointFeatures {
    typealias TestShapePoints = (Move: TestRefreshShapeMovePoint, Add: TestRefreshShapeAddLinePoint)
    
    func makeMovePoint(in rect: CGRect, radians: Double) -> TestRefreshShapeMovePoint
    func makeAddLinePoint(in rect: CGRect, radians: Double) -> TestRefreshShapeAddLinePoint
    func makeAddLinePoint(in rect: CGRect, radians: Double, movePoint: TestRefreshShapeMovePoint) -> TestRefreshShapeAddLinePoint
    func makeShapePoints(in rect: CGRect, radians: Double) -> TestShapePoints
}

public protocol TestShapeFeatures: TestShapePointFeatures { }
