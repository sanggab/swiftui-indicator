//
//  Helper.swift
//  GabIndicator
//
//  Created by Gab on 11/15/24.
//

import SwiftUI

final class TrigonometricCalculator: ShapePointFeatures, Sendable {
    
    static let `default` = TrigonometricCalculator()
    
    private init() { }
    
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
    func makeShapePoints(in rect: CGRect, radians: Double) -> ShapePointFeatures.ShapePoints {
        let movePoint = self.makeMovePoint(in: rect, radians: radians)
        let addLinePoint = self.makeAddLinePoint(in: rect, radians: radians, movePoint: movePoint)
        
        return (movePoint, addLinePoint)
    }
}
