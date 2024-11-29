//
//  Redefinition.swift
//  GabIndicator
//
//  Created by Gab on 11/29/24.
//

import SwiftUI

struct RedefinitionDecimals: OptionSet {
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let `ceil` = RedefinitionDecimals(rawValue: 1 << 0)
    
    static let `round` = RedefinitionDecimals(rawValue: 1 << 1)
    
    static let `floor` = RedefinitionDecimals(rawValue: 1 << 2)
    
    static let `trunc` = RedefinitionDecimals(rawValue: 1 << 3)
}
