//
//  RefreshIndicator.swift
//  GabIndicator
//
//  Created by Gab on 11/18/24.
//

import SwiftUI

/// 새로고침 Indicator
///
/// Apple에서 제공해주는 UIRefreshControl하고 같은 디자인을 취하지만, 각종 modifier()들로 원하는 스타일로 변경이 가능합니다.
public struct RefreshIndicator: View {
    @ObservedObject private var viewModel: ShapeViewModel = ShapeViewModel()
    
    /// RefreshIndicator을 만듭니다.
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
            
            if currentAngle >= 360.0 {
                currentAngle = viewModel(\.wingState.angle)
            } else {
                currentAngle += viewModel(\.wingState.angle)
            }
            
            viewModel.action(.wing(.setStartAngle(currentAngle)))
        }
        .onAppear {
            setStartAngle()
            viewModel.action(.timer(.setTimer))
        }
    }
}

// MARK: - RefreshIndicator Modifier
public extension RefreshIndicator {
    /// `RefreshIndicator`에 `strokeStyle`을 적용시킵니다.
    ///
    /// `RefreshIndicator`의 `lines`에 대해 커스텀이 필요한 경우 `Shape`에 `strokeStyle`을 적용시킨 것 처럼 사용하면 됩니다.
    ///
    /// - parameter style: `Shape`의 `StrokeStyle` 입니다.
    ///
    /// - Returns: `RefreshIndicator`
    ///
    /// - Tip: RefreshIndicator의 line의 Color을 변경하고 싶다면 ``foregroundStyle(_:)``을 사용하면 됩니다.
    func strokeStyle(style: StrokeStyle) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setStyle(style)))
        return view
    }
    /// `RefreshIndicator`의 각 `line` 사이의 각도를 결정합니다.
    ///
    /// 360도를 기준으로 설정한 `angle`을 나눠서 나온 값을 가지고 `RefreshIndicator`의 `line` 개수를 설정합니다.
    ///
    /// - parameter angle: 각도
    ///
    /// - returns: `RefreshIndicator`
    ///
    /// - Note: 만약 360도로 나눈 값이 유리수로 떨어진 경우에, 정수로 변형시켜서 `line` 개수를 설정하기 때문에 UI가 이상해질 수 있습니다.
    ///
    /// - warning: ``setRedefinitionAngle(angle:_:)`` 하고 동시에 사용할 경우, 나중에 사용한 modifier가 적용됩니다.
    func setAngle(angle: Double) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setAngle(angle)))
        return view
    }
    /// `RefreshIndicator`의 각 `line` 사이의 각도를 결정합니다.
    ///
    /// 360도를 기준으로 설정한 `angle`을 나눠서 나온 값을 ``RedefinitionDecimals`` 옵션에 따라 소수점 처리를 진행해서 `RefreshIndicator`의 `line` 개수를 설정합니다.
    ///
    /// - Parameters:
    ///     - angle: 각도
    ///     - mode: ``RedefinitionDecimals``
    ///
    /// - returns: `RefreshIndicator`
    ///
    /// - Note: ``setAngle(angle:)`` 하고 다른 점은 360도를 기준으로 설정한 `angle`을 나눴을 때, 유리수가 나와도 `angle`을 `redefinition`해서 UI가 자연스럽게 보이냐 안보이냐 차이 입니다.
    ///
    /// - warning: ``setAngle(angle:)`` 하고 동시에 사용할 경우, 나중에 사용한 modifier가 적용됩니다.
    func setRedefinitionAngle(angle: Double, _ mode: RedefinitionDecimals = .round) -> RefreshIndicator {
        let view: RefreshIndicator = self
        view.viewModel.action(.wing(.setRedefinitionAngleMode(mode)))
        view.viewModel.action(.wing(.setRedefinitionAngle(angle)))
        return view
    }
    /// `RefreshIndicator`의 애니메이션 속도를 설정합니다.
    ///
    /// - parameter duration: 시간
    ///
    /// - returns: `RefreshIndicator`
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
    // startAngle을 정하는 수단은 90도를 기준으로 현재 angle을 나눈 몫에 angle을 곱해주면 된다.
    private func setStartAngle() {
        let angle = viewModel(\.wingState.angle)
        let newAngle = floor(90 / angle) * viewModel(\.wingState.angle)
        viewModel.action(.wing(.setStartAngle(-newAngle)))
    }
}

#Preview {
    RefreshIndicator()
        .strokeStyle(style: StrokeStyle(lineWidth: 5,
                                        lineCap: .round,
                                        lineJoin: .round))
        .setRedefinitionAngle(angle: 36)
        .setSpeed(duration: 10)
        .frame(width: 50, height: 25)
}
