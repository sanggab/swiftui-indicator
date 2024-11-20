//
//  WingShape.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI

struct WingShape: Shape {
    let degress: Double
    
    init(degress: Double) {
        self.degress = degress
    }
    
    func path(in rect: CGRect) -> Path {
        drawWing(in: rect)
    }
    
    func drawWing(in rect: CGRect) -> Path {
        Path { path in
            let radians = degress * .pi / 180
            let shapePoint = TrigonometricCalculator.default.makeShapePoints(in: rect, radians: radians)
            print("상갑 logEvent \(#function) degress: \(degress)")
            print("상갑 logEvent \(#function) shapePoint: \(shapePoint)")
            path.move(to: shapePoint.Move.toCGPoint())
            path.addLine(to: shapePoint.Add.toCGPoint())
            
            path.closeSubpath()
        }
    }
}

#Preview {
    ZStack {
        WingShape(degress: 0)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .opacity(1)
            .frame(width: 20, height: 20)
        
        WingShape(degress: 45)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .opacity(0.75)
            .frame(width: 20, height: 20)
        
        WingShape(degress: 90)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .opacity(0.5)
            .frame(width: 20, height: 20)
        
        WingShape(degress: 135)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .opacity(0.25)
            .frame(width: 20, height: 20)
    }
}
