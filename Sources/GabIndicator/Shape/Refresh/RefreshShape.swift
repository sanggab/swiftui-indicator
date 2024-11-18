//
//  RefreshShape.swift
//  GabIndicator
//
//  Created by Gab on 11/12/24.
//

import SwiftUI
/// Traits를 이용한 실험
struct RefreshShape: View {
    @EnvironmentObject private var viewModel: ShapeViewModel
    
    var body: some View {
        shape1
    }
    
    
    @available(*, deprecated, renamed: "shape2", message: "상장폐지")
    @ViewBuilder
    private var shape1: some View {
        ZStack {
            ForEach(0..<viewModel(\.wingState.wingCount), id: \.self) { index in
                WingShape(degress: getDegress(index: index))
                    .stroke(style: viewModel(\.wingState.strokeStyle))
                    .opacity(getOpacity(index: index))
            }
            
            Button {
                if viewModel(\.timerState).existCancellables() {
                    viewModel.action(.timer(.stopTimer))
                } else {
                    viewModel.action(.timer(.setSpeed(0.05)))
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
            viewModel.action(.wing(.setStyle(StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))))
            viewModel.action(.timer(.setSpeed(0.05)))
//            viewModel.action(.timer(.setTimer))
        }
    }
    
    @ViewBuilder
    private var shape2: some View {
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
                    viewModel.action(.timer(.setSpeed(0.05)))
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
            viewModel.action(.wing(.setStyle(StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))))
            viewModel.action(.wing(.setRotateAngle(getDegress(index: 0))))
        }
    }
}

extension RefreshShape {
    /// 현재 wing의 degress를 결정짓는 요소
    /// .rotationEffect의 역할
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
}

@available(iOS 18.0, *)
#Preview(traits: .shapeViewModel) {
    RefreshShape()
        .frame(width: 50, height: 50)
//        .foregroundStyle(.mint)
}
