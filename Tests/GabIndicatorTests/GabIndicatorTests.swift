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
    
    @Suite("RefreshShpaeTest",
           .tags(.refreshSuite))
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
        
        
        @Test("ShapePointFeatureTest",
              arguments: [ [15.0, 30.0, 45.0, 60.0, 75.0, 90.0].randomElement() ?? .zero ])
        func shapePointFeatureTest(degress: Double) async throws {
            print("상갑 logEvent \(#function) degress: \(degress)")
            let rect = CGRect(x: 0,
                              y: 0,
                              width: 50,
                              height: 50)
            
            let radians = degress * .pi / 180
            
            let movePoint = viewModel.makeMovePoint(in: rect,
                                                    radians: radians)
            
            let addLinePoint = viewModel.makeAddLinePoint(in: rect,
                                                          radians: radians,
                                                          movePoint: movePoint)
            
            let addLinePoint2 = viewModel.makeAddLinePoint(in: rect,
                                                           radians: radians)
            
            try #require(addLinePoint == addLinePoint2)
            
            let shapePoint = viewModel.makeShapePoints(in: rect, radians: radians)
            
            #expect(shapePoint.Move == movePoint && shapePoint.Add == addLinePoint && shapePoint.Add == addLinePoint2)
        }
        
        @available(iOS 16.0, *)
        @Test("ShapePointFeatureTest - timeLimit",
              .timeLimit(.minutes(1)),
              arguments: [ [15.0, 30.0, 45.0, 60.0, 75.0, 90.0].randomElement() ?? .zero ])
        func shapePointFeatureTest2(degress: Double) async throws {
            print("상갑 logEvent \(#function) degress: \(degress)")
            let rect = CGRect(x: 0,
                              y: 0,
                              width: 50,
                              height: 50)
            
            let radians = degress * .pi / 180
            
            let movePoint = viewModel.makeMovePoint(in: rect,
                                                    radians: radians)
            
            let addLinePoint = viewModel.makeAddLinePoint(in: rect,
                                                          radians: radians,
                                                          movePoint: movePoint)
            
            let addLinePoint2 = viewModel.makeAddLinePoint(in: rect,
                                                           radians: radians)
            
            try #require(addLinePoint == addLinePoint2)
            
            let shapePoint = viewModel.makeShapePoints(in: rect, radians: radians)
            
            #expect(shapePoint.Move == movePoint && shapePoint.Add == addLinePoint && shapePoint.Add == addLinePoint2)
        }
        
        @Test("WingTest",
              arguments: zip([ [15.0, 30.0, 45.0, 60.0, 75.0, 90.0].randomElement() ?? .zero ],
                             [ [CGRect(x: 0, y: 0, width: 20, height: 20),
                                CGRect(x: 0, y: 0, width: 40, height: 40)].randomElement() ?? .zero ] ))
        func wingTest(angle: Double, rect: CGRect) async throws {
            print("상갑 logEvent \(#function)")
            
            try #require(viewModel(\.wingState.angle) == viewModel(\.wingState.rotateAngle))
            
            viewModel.action(.wing(.setAngle(angle)))
            
            try #require(viewModel(\.wingState.angle) == viewModel(\.wingState.rotateAngle))
            
            try #require(viewModel(\.wingState.wingCount) == Int(abs(360 / angle)))
            
            viewModel.action(.wing(.setStyle(StrokeStyle(lineWidth: rect.width / 4, lineCap: .round, lineJoin: .round))))
            
            #expect(viewModel(\.wingState.strokeStyle).lineWidth == rect.width / 4)
            
            viewModel.action(.wing(.setRotateAngle(90)))
            
            #expect(viewModel(\.wingState.angle) != viewModel(\.wingState.rotateAngle))
            
            try #require(viewModel(\.wingState.isPlaying))
            
            viewModel.action(.wing(.control(false)))
            
            #expect(!viewModel(\.wingState.isPlaying))
        }
        
        @Test("Redefinition Of Angle Test",
              arguments: [[41.0, 51.0].randomElement() ?? .zero])
        func wingAngleTest(angle: Double) async throws {
            viewModel.action(.wing(.redefinitionAngle(angle)))
            
            #expect(viewModel(\.wingState.angle) != angle)
            #expect(viewModel(\.wingState.wingCount) != Int(360 / viewModel(\.wingState.angle)))
        }
        
        @Test("Start Angle Test",
              arguments: [[31.0, 56.0, 72.0, 102.0].randomElement() ?? .zero])
        func startAngleTest(angle: Double) async throws {
            viewModel.action(.wing(.setStartAngle(angle)))
            
            #expect(viewModel(\.wingState.startAngle) == angle)
            
        }
    }
}
