//
//  RefreshIndicator.swift
//  GabIndicator
//
//  Created by Gab on 11/15/24.
//

import SwiftUI

public struct RefreshIndicator: View {
    @ObservedObject private var viewModel: ShapeViewModel = ShapeViewModel()
    
    public var body: some View {
        RefreshShape()
            .frame(width: 20, height: 20)
    }
}

#Preview {
    RefreshIndicator()
}
