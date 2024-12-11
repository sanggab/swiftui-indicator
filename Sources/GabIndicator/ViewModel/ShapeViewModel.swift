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
            self.timer = Timer.publish(every: self.speed, on: .main, in: .default)
            self.timer.connect().store(in: &cancellable)
        }
        
        mutating func stopTimer() {
            self.cancellable.removeAll()
        }
        
        func existCancellables() -> Bool {
            return !self.cancellable.isEmpty
        }
    }
    
    
    struct WingState: Equatable {
        init() { }
        
        var angle: Double = 45.0
        var startAngle: Double = 45.0
        
        var wingCount: Int = 8
        
        var redefinitionAngleMode: RedefinitionDecimals = .none
        
        var strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2,
                                                          lineCap: .round,
                                                          lineJoin: .round)
        
        @available(*, deprecated, renamed: "startAngle", message: "startAngle로 대체")
        var rotateAngle: Double = 45.0
        
        @available(*, deprecated, message: "잠정 샷다운")
        var isPlaying: Bool = true
    }
    
    /// hi
    struct State: Equatable {
        init() { }
        
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
            case setWingCount(Int)
            
            case setStartAngle(Double)
            case setRedefinitionAngle(Double)
            case setRedefinitionAngleMode(RedefinitionDecimals)
            
            @available(*, deprecated, message: "setStartAngle(Double)로 대체")
            case setRotateAngle(Double)
            
            @available(*, deprecated, message: "setRedefinitionAngle(Double)로 대체")
            case redefinitionAngle(Double)
            
            @available(*, deprecated, message: "잠정 샷다운")
            case control(Bool)
        }
    }
    
    @Published private var state: State = .init()
    
    func action(_ action: Action) {
        switch action {
        case .timer(let timerAC):
            self.timerAction(timerAC)
        case .wing(let wingAC):
            self.wingAction(wingAC)
        }
    }
    
    private func timerAction(_ action: Action.Timer) {
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
        switch action {
        case .setAngle(let angle):
            if self(\.wingState.redefinitionAngleMode) != .none {
                self.update(\.wingState.redefinitionAngleMode, newValue: .none)
            }
            
            self.update(\.wingState.angle, newValue: angle)
            
            let wingCount = Int(abs(360 / self(\.wingState.angle)))
            
            self.wingAction(.setWingCount(wingCount))
            
        case .setStartAngle(let angle):
            self.update(\.wingState.startAngle, newValue: angle)
            
        case .setRedefinitionAngle(let angle):
            let redifinitionAngle = self.redifinitionAngle(angle: angle)
            
            self.update(\.wingState.angle, newValue: redifinitionAngle)
            
        case .setRedefinitionAngleMode(let mode):
            self.update(\.wingState.redefinitionAngleMode, newValue: mode)
            
        case .setStyle(let strokeStyle):
            self.update(\.wingState.strokeStyle, newValue: strokeStyle)
            
        case .setWingCount(let count):
            self.update(\.wingState.wingCount, newValue: count)
            
        default:
            break
            
//        case .setRotateAngle(let angle):
//            self.update(\.wingState.rotateAngle, newValue: angle)
//            
//        case .redefinitionAngle(let angle):
//            let redifinitionAngle = self.redifinitionAngle(angle: angle)
//            self.update(\.wingState.angle, newValue: redifinitionAngle)
//            
//            if redifinitionAngle != self(\.wingState.rotateAngle) {
//                self.wingAction(.setRotateAngle(redifinitionAngle))
//            }
//            
//        case .control(let status):
//            self.update(\.wingState.isPlaying, newValue: status)
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
    
    private func redifinitionAngle(angle: Double) -> Double {
        let newWingCount = self.redifinitionWingCount(count: 360 / angle)
        self.action(.wing(.setWingCount(Int(newWingCount))))
        
        let newAngle: Double = 360 / newWingCount
        
        return newAngle
    }
    
    private func redifinitionWingCount(count: Double) -> Double {
        var redifiCount: Double = count
        
        switch self(\.wingState.redefinitionAngleMode) {
        case .ceil:
            redifiCount = ceil(count)
        case .round:
            redifiCount = round(count)
        case .floor:
            redifiCount = floor(count)
        case .trunc:
            redifiCount = trunc(count)
        default:
            break
        }
        
        return redifiCount
    }
}
