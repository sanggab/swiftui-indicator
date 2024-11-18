//
//  RefreshIndicator.swift
//  GabIndicator
//
//  Created by Gab on 11/18/24.
//

import SwiftUI

public struct RefreshIndicator: View {
    @ObservedObject private var viewModel: ShapeViewModel = ShapeViewModel()
    
    public init() { }
    
    public var body: some View {
        main
    }
    
    @ViewBuilder
    private var main: some View {
        ZStack {
            ForEach(0..<viewModel(\.wingState.wingCount), id: \.self) { index in
                WingShape(degress: viewModel(\.wingState.rotateAngle))
                    .stroke(style: viewModel(\.wingState.strokeStyle))
                    .rotationEffect(.degrees(viewModel(\.wingState.angle)) * Double(index))
                    .opacity(getOpacity(index: index))
            }
            
            Button {
                if viewModel(\.timerState).existCancellables() {
                    viewModel.action(.timer(.stopTimer))
                } else {
//                    viewModel.action(.timer(.setSpeed(0.05)))
                    viewModel.action(.timer(.setTimer))
                }
            } label: {
                if viewModel(\.timerState).existCancellables() {
                    Text("멈춰!")
                } else {
                    Text("시작!")
                }
            }

        }
        .onReceive(viewModel(\.timerState).timer) { _ in
            var currentAngle = viewModel(\.wingState.rotateAngle)
            if currentAngle == 360.0 {
                currentAngle = viewModel(\.wingState.angle)
            } else {
                currentAngle += viewModel(\.wingState.angle)
            }
            
            viewModel.action(.wing(.setRotateAngle(currentAngle)))
        }
        .onAppear {
            print("상갑 logEvent \(#function) onAppear")
            viewModel.action(.wing(.setRotateAngle(getDegress(index: 0))))
        }
    }
}

// MARK: - RefreshIndicator Modifier
public extension RefreshIndicator {
    func strokeStyle(style: StrokeStyle) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setStyle(style)))
        return view
    }
    
    func setAngle(angle: Double) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setAngle(angle)))
        return view
    }
    
    func setSpeed(duration: Double) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.timer(.setSpeed(duration)))
        return view
    }
}

extension RefreshIndicator {
    /// 현재 wing의 degress를 결정짓는 요소
    /// .rotationEffect의 역할
    private func getDegress(index: Int) -> Double {
        /// 원래대로 그린다면 정해지는 Angle
        let currentAngle = (viewModel(\.wingState.angle) * Double(index))
        /// Timer에 의해 currentAngle에서 돌릴 Angle
        let rotateAngle = viewModel(\.wingState.rotateAngle)
        /// Swift에서 Path를 이용해 각도를 계산하거나 addArc등 그릴 경우에, 0도는 3시방향이라 이것을 12시 방향으로 돌리기 위한 각도
        let moveAngle = 90 + viewModel(\.wingState.angle)
        print("상갑 logEvent \(#function) moveAngle : \(moveAngle)")
        return currentAngle + rotateAngle - moveAngle
    }
    /// Opacity를 구하는 method
    private func getOpacity(index: Int) -> Double {
        if index == .zero {
            return 1.0
        } else {
            let count = viewModel(\.wingState.wingCount)
            
            if index > 0 && index <= (count / 2) {
                return 0.25
            } else {
                let sliceOpacity = 1 / Double(count)
                
                return sliceOpacity * Double(index)
            }
        }
    }
}

#Preview {
    RefreshIndicator()
        .strokeStyle(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        .setAngle(angle: 45)
        .setSpeed(duration: 0.1)
        .frame(width: 50, height: 50)
//        .foregroundColor(Color.green)
}