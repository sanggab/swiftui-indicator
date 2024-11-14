//
//  GabIndicatorTests + ViewModel.swift
//  GabIndicatorTests
//
//  Created by Gab on 11/13/24.
//

import SwiftUI
import Combine

public class TestShapeViewModel: TestGabReducer {
    
    public struct TimerState: Equatable {
        public static func == (lhs: TestShapeViewModel.TimerState, rhs: TestShapeViewModel.TimerState) -> Bool {
            return lhs.speed == rhs.speed &&
            lhs.cancellable == rhs.cancellable
        }
        
        public init() {
            self.timer = Timer.publish(every: self.speed, on: .main, in: .default)
        }
        
        public var timer: Timer.TimerPublisher
        private var cancellable: Set<AnyCancellable> = []
        public var speed: Double = .zero
        
        mutating public func setTimer() {
            print("상갑 logEvent \(#function)")
            // MARK: Timer의 autoConnect의 장점은 멀까 - 어차피 every의 시간마다 호출되서 View가 Draw될 때 바로 onReceive에 구독되는 것도 아닌데..
            self.timer = Timer.publish(every: self.speed, on: .main, in: .default)
            
            self.timer.sink { output in
                print("상갑 logEvent \(#function) output: \(output)")
            }.store(in: &cancellable)
            
            self.timer.connect().store(in: &cancellable)
        }
        
        mutating public func stopTimer() {
            print("상갑 logEvent \(#function)")
            self.cancellable.removeAll()
        }
        
        func existCancellables() -> Bool {
            return !self.cancellable.isEmpty
        }
    }
    
    public struct State: Equatable {
        public init () { }
        
        public var timerState: TimerState = .init()
    }
    
    public enum Action: Equatable {
        case timer(Action.Timer)
        
        public enum Timer: Equatable {
            case setSpeed(Double)
            case setTimer
            case stopTimer
        }
    }
    
    @Published private var state: State = .init()
    
    public func action(_ action: Action) {
        print("상갑 logEvent \(#function) action: \(action)")
        switch action {
        case .timer(let timerAC):
            self.timerAction(timerAC)
        }
    }
    
    private func timerAction(_ action: Action.Timer) {
        print("상갑 logEvent \(#function) action: \(action)")
        switch action {
        case .setSpeed(let double):
            self.update(\.timerState.speed, newValue: double)
        case .setTimer:
            if self.state.timerState.speed == .zero {
                self.timerAction(.setSpeed(1.5))
            }
            self.setTimer()
        case .stopTimer:
            self.stopTimer()
        }
    }
}

extension TestShapeViewModel {
    public func callAsFunction<V>(_ keyPath: KeyPath<State, V>) -> V where V : Equatable {
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
