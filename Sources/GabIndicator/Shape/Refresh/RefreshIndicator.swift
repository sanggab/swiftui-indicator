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
                WingShape(degress: viewModel(\.wingState.startAngle))
                    .stroke(style: viewModel(\.wingState.strokeStyle))
                    .rotationEffect(.degrees(viewModel(\.wingState.angle)) * Double(index))
                    .opacity(getOpacity(index: index))
            }
        }
        .onReceive(viewModel(\.timerState).timer) { _ in
            var currentAngle = viewModel(\.wingState.startAngle)
            if currentAngle == 360.0 {
                currentAngle = viewModel(\.wingState.angle)
            } else {
                currentAngle += viewModel(\.wingState.angle)
            }
            
            viewModel.action(.wing(.setStartAngle(currentAngle)))
        }
        .onAppear {
            setStartAngle()
//            viewModel.action(.timer(.setTimer))
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
    
    func setRedefinitionAngle(angle: Double) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setRedefinitionAngle(angle)))
        return view
    }
    
    func setSpeed(duration: Double) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.timer(.setSpeed(duration)))
        return view
    }
    @available(*, deprecated, message: "멈추고 플레이 안되는 문제로 추후 재개발")
    func controlIndicator(state: Bool) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.control(state)))
        return view
    }
}

extension RefreshIndicator {
    /// 현재 wing의 degress를 결정짓는 요소
    /// .rotationEffect의 역할
    @available(*, deprecated, renamed: "rotateAngle()", message: "360도로 안떨어지는 Angle에서 문제가 발생해서 deprecated")
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
    // rotate를 정하는 수단은 90도를 기준으로 현재 angle을 나눈 몫에 angle을 곱해주면 된다.
    private func setStartAngle() {
        let angle = viewModel(\.wingState.angle)
        let newAngle = floor(90 / angle) * viewModel(\.wingState.angle)
        viewModel.action(.wing(.setStartAngle(-newAngle)))
    }
}

#Preview {
    RefreshIndicator()
        .strokeStyle(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//        .setAngle(angle: 36)
        .setRedefinitionAngle(angle: 40)
        .setSpeed(duration: 0.08)
        .controlIndicator(state: true)
        .frame(width: 50, height: 50)
}
