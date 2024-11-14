//
//  Point.swift
//  GabIndicator
//
//  Created by Gab on 11/14/24.
//

import SwiftUI


struct RefreshShapeMovePoint: Equatable {
    var x: CGFloat
    var y: CGFloat
    
    static let `default` = RefreshShapeMovePoint(x: .zero, y: .zero)
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}


struct RefreshShapeAddLinePoint: Equatable {
    var x: CGFloat
    var y: CGFloat
    
    static let `default` = RefreshShapeAddLinePoint(x: .zero, y: .zero)
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}
