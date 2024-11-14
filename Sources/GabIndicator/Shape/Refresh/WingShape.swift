//
//  WingShape.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI

struct WingShape: Shape {
    @EnvironmentObject private var shapeViewModel: ShapeViewModel
    
    
    var degress: Double
    
    init(degress: Double) {
        self.degress = degress
    }
    
    func path(in rect: CGRect) -> Path {
        drawWing(in: rect)
    }
    
    func drawWing(in rect: CGRect) -> Path {
        Path { path in
            let radians = self.degress * .pi / 180
        }
    }
}

@available(iOS 18.0, *)
#Preview(traits: .shapeViewModel) {
    WingShape(degress: 45.0)
        .frame(width: 20, height: 20)
}
