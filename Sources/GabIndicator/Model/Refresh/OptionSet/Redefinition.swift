//
//  Redefinition.swift
//  GabIndicator
//
//  Created by Gab on 11/29/24.
//

import SwiftUI

/// Angle을 재정의할 때, 소수점 처리를 결정하는 옵션
///
/// RefreshIndicator의 Angle을 재정의를 할 때, Angle의 소수점 처리를 안 할지, 아니면 올림 / 반올림 / 내림 방식을 결정한다.
///
/// - Note: 360도에서 내가 설정한 Angle을 나눌 때, 소수점으로 나눠지는 경우에 RefreshIndicator의 날개의 개수가 정수로 안 떨어지면 UI가 이상해져서 소수점을 처리하기 위해서 사용되는 옵션
@frozen
public struct RedefinitionDecimals: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int = 0 << 0) {
        self.rawValue = rawValue
    }
    
    /// 기본 옵션.
    /// 소수점 처리를 안함
    public static let none = RedefinitionDecimals(rawValue: 0 << 0)
    /// 소수점 올림
    public static let `ceil` = RedefinitionDecimals(rawValue: 1 << 0)
    /// 소수점 반올림
    public static let `round` = RedefinitionDecimals(rawValue: 1 << 1)
    /// 소수점 내림
    public static let `floor` = RedefinitionDecimals(rawValue: 1 << 2)
    /// 소수점 내림
    public static let `trunc` = RedefinitionDecimals(rawValue: 1 << 3)
}
