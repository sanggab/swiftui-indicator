//
//  WingShape.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI

struct WingShape: Shape {
    
    var degress: Double
    
    init(degress: Double) {
        self.degress = degress
    }
    
    func path(in rect: CGRect) -> Path {
        drawWing(in: rect)
    }
    
    func drawWing(in rect: CGRect) -> Path {
        Path { path in
            let radians = degress * .pi / 180
        }
    }
}

#Preview {
    WingShape(degress: 45.0)
}
