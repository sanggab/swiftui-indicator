//
//  ShapeViewModel.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/14/24.
//

import SwiftUI
import Combine

final class ShapeViewModel: GabReducer {
    struct TimerState: Equatable {
        static func == (lhs: ShapeViewModel.TimerState, rhs: ShapeViewModel.TimerState) -> Bool {
            return lhs.speed == rhs.speed &&
            lhs.cancellable == rhs.cancellable
        }
        
        init() {
            self.timer = Timer.publish(every: self.speed, on: .main, in: .default)
        }
        
        private var cancellable: Set<AnyCancellable> = []
        
        var timer: Timer.TimerPublisher
        var speed: Double = .zero
        
        mutating func setTimer() {
//            print("상갑 logEvent \(#function)")
            // MARK: Timer의 autoConnect의 장점은 멀까 - 어차피 every의 시간마다 호출되서 View가 Draw될 때 바로 onReceive에 구독되는 것도 아닌데..
            self.timer = Timer.publish(every: self.speed, on: .main, in: .default)
            
//            self.timer.sink { output in
//                print("상갑 logEvent \(#function) output: \(output)")
//            }.store(in: &cancellable)
            
            self.timer.connect().store(in: &cancellable)
        }
        
        mutating func stopTimer() {
//            print("상갑 logEvent \(#function)")
            self.cancellable.removeAll()
        }
        
        func existCancellables() -> Bool {
            return !self.cancellable.isEmpty
        }
    }
    
    
    struct WingState: Equatable {
        init () { }
        
        var angle: Double = 45.0
        var strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2,
                                                          lineCap: .round,
                                                          lineJoin: .round)
        var rotateAngle: Double = 45.0
        var wingCount: Int = 8
        var isPlaying: Bool = true
    }
    
    struct State: Equatable {
        init () { }
        
        var timerState: TimerState = .init()
        var wingState: WingState = .init()
    }
    
    enum Action: Equatable {
        case timer(Action.Timer)
        case wing(Action.Wing)
        
        enum Timer: Equatable {
            case setSpeed(Double)
            case setTimer
            case stopTimer
        }
        
        enum Wing: Equatable {
            case setAngle(Double)
            case setStyle(StrokeStyle)
            case setRotateAngle(Double)
            case setWingCount(Int)
            case control(Bool)
        }
    }
    
    @Published private var state: State = .init()
    
    func action(_ action: Action) {
//        print("상갑 logEvent \(#function) action: \(action)")
        switch action {
        case .timer(let timerAC):
            self.timerAction(timerAC)
        case .wing(let wingAC):
            self.wingAction(wingAC)
        }
    }
    
    private func timerAction(_ action: Action.Timer) {
//        print("상갑 logEvent \(#function) action: \(action)")
        switch action {
        case .setSpeed(let speed):
            self.update(\.timerState.speed, newValue: speed)
        case .setTimer:
            if self.state.timerState.speed == .zero {
                self.timerAction(.setSpeed(1.5))
            }
            self.setTimer()
        case .stopTimer:
            self.stopTimer()
        }
    }
    
    private func wingAction(_ action: Action.Wing) {
//        print("상갑 logEvent \(#function) action: \(action)")
        switch action {
        case .setAngle(let angle):
            self.update(\.wingState.angle, newValue: angle)
            
            if angle != self(\.wingState.rotateAngle) {
                self.wingAction(.setRotateAngle(angle))
            }
            
            let wingCount = Int(abs(360 / self(\.wingState.angle)))
            self.wingAction(.setWingCount(wingCount))
        case .setStyle(let strokeStyle):
            self.update(\.wingState.strokeStyle, newValue: strokeStyle)
        case .setRotateAngle(let angle):
            self.update(\.wingState.rotateAngle, newValue: angle)
        case .setWingCount(let count):
            self.update(\.wingState.wingCount, newValue: count)
        case .control(let status):
            self.update(\.wingState.isPlaying, newValue: status)
        }
    }
}

extension ShapeViewModel {
    func callAsFunction<V>(_ keyPath: KeyPath<State, V>) -> V where V : Equatable {
        return self.state[keyPath: keyPath]
    }
    
    private func update<V>(_ keyPath: WritableKeyPath<State, V>, newValue: V) where V : Equatable {
        self.state[keyPath: keyPath] = newValue
    }
    
    private func setTimer() {
        self.state.timerState.setTimer()
    }
    
    private func stopTimer() {
        self.state.timerState.stopTimer()
    }
}
