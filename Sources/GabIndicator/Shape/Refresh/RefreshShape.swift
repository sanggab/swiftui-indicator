//
//  RefreshShape.swift
//  GabIndicator
//
//  Created by Gab on 11/12/24.
//

import SwiftUI

public struct RefreshShape: View {
    @EnvironmentObject private var viewModel: ShapeViewModel
    
    public var body: some View {
        WingShape(degress: 0)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .frame(width: 20, height: 20)
    }
}

@available(iOS 18.0, *)
#Preview(traits: .shapeViewModel) {
    RefreshShape()
}
