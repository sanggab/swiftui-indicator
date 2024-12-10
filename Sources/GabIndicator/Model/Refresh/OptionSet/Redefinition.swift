//
//  Redefinition.swift
//  GabIndicator
//
//  Created by Gab on 11/29/24.
//

import SwiftUI

@frozen
public struct RedefinitionDecimals: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let none = RedefinitionDecimals(rawValue: 0 << 0)
    
    public static let `ceil` = RedefinitionDecimals(rawValue: 1 << 0)
    
    public static let `round` = RedefinitionDecimals(rawValue: 1 << 1)
    
    public static let `floor` = RedefinitionDecimals(rawValue: 1 << 2)
    
    public static let `trunc` = RedefinitionDecimals(rawValue: 1 << 3)
}
