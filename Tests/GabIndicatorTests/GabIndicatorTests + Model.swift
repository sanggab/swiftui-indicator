//
//  GabIndicatorTests + Model.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI
import Foundation

@frozen
public struct TestRefreshShapeMovePoint: Equatable {
    public var x: CGFloat
    public var y: CGFloat
    
    public static let `default` = TestRefreshShapeMovePoint(x: .zero, y: .zero)
    
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
    
    public static let `default` = TestRefreshShapeAddLinePoint(x: .zero, y: .zero)
    
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
public struct TestRedefinitionAngleOption: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let `ceil` = TestRedefinitionAngleOption(rawValue: 1 << 0)
    
    public static let `round` = TestRedefinitionAngleOption(rawValue: 1 << 1)
    
    public static let `floor` = TestRedefinitionAngleOption(rawValue: 1 << 2)
    
    public static let `trunc` = TestRedefinitionAngleOption(rawValue: 1 << 3)
}
