//
//  PreviewTraits.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/14/24.
//

import SwiftUI

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var shapeViewModel: Self = .modifier(ShapeViewModelTraits())
}


struct ShapeViewModelTraits: PreviewModifier {
    typealias Context = ShapeViewModel
    
    static func makeSharedContext() async throws -> Context {
        return ShapeViewModel()
    }
    
    func body(content: Content, context: Context) -> some View {
        content.environmentObject(context)
    }
}
