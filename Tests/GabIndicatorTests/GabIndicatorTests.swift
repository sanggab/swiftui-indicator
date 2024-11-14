//
//  GabIndicatorTests.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/12/24.
//

import SwiftUI
import Testing
@testable import GabIndicator

struct GabIndicatorTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

extension GabIndicatorTests {
    
    @Suite("RefreshShpaeTest", .tags(.refreshSuite))
    struct RefreshShapeTest {
        @ObservedObject var viewModel: TestShapeViewModel = TestShapeViewModel()
        
        @Test("TimerTest")
        func timerTest() async throws {
            try #require(viewModel(\.timerState).existCancellables() == false)
            
            viewModel.action(.timer(.setTimer))
            #expect(viewModel(\.timerState.speed) == 1.5)
            
            try await Task.sleep(nanoseconds: 3_000_000_000)
            
            try #require(viewModel(\.timerState).existCancellables() == true)
            
            viewModel.action(.timer(.stopTimer))
            
            #expect(viewModel(\.timerState).existCancellables() == false)
        }
        
//        @Test("WingShapeTest")
//        func wingShapeTest() async throws {
//            
//        }
    }
}
