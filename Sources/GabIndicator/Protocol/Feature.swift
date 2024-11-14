//
//  Feature.swift
//  GabIndicator
//
//  Created by Gab on 11/14/24.
//

import SwiftUI

protocol ShapePointFeatures {
    typealias ShapePoints = (Move: RefreshShapeMovePoint, Add: RefreshShapeAddLinePoint)
    
    func makeMovePoint(in rect: CGRect, radians: Double) -> RefreshShapeMovePoint
    func makeAddLinePoint(in rect: CGRect, radians: Double) -> RefreshShapeAddLinePoint
    func makeAddLinePoint(in rect: CGRect, radians: Double, movePoint: RefreshShapeMovePoint) -> RefreshShapeAddLinePoint
    func makeShapePoints(in rect: CGRect, radians: Double) -> ShapePoints
}

protocol ShapeMainFeatures: ShapePointFeatures { }
