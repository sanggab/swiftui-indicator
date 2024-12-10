//
//  GabIndicatorTests + Model.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI
import Foundation

struct TestRefreshShapeMovePoint: Equatable {
    var x: CGFloat
    var y: CGFloat
    
    static let `default` = TestRefreshShapeMovePoint(x: .zero, y: .zero)
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}

struct TestRefreshShapeAddLinePoint: Equatable {
    var x: CGFloat
    var y: CGFloat
    
    static let `default` = TestRefreshShapeAddLinePoint(x: .zero, y: .zero)
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x,
                       y: y)
    }
}

struct TestRedefinitionAngleOption: OptionSet {
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let `ceil` = TestRedefinitionAngleOption(rawValue: 1 << 0)
    
    static let `round` = TestRedefinitionAngleOption(rawValue: 1 << 1)
    
    static let `floor` = TestRedefinitionAngleOption(rawValue: 1 << 2)
    
    static let `trunc` = TestRedefinitionAngleOption(rawValue: 1 << 3)
}
