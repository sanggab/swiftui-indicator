//
//  GabIndicatorTests + Model.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI

@frozen
public struct TestRefreshShapeMovePoint: Equatable {
    public var x: CGFloat
    public var y: CGFloat
    
    static let `default` = TestRefreshShapeMovePoint(x: .zero, y: .zero)
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}

@frozen
public struct TestRefreshShapeAddLinePoint: Equatable {
    public var x: CGFloat
    public var y: CGFloat
    
    static let `default` = TestRefreshShapeAddLinePoint(x: .zero, y: .zero)
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}
