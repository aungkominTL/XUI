//
//  PhaseAnimation.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/5/24.
//

import SwiftUI

private struct PhaseAnimationModifier: ViewModifier {
    let phases: [PhaseAnimationType]
    let trigger: String?
    func body(content: Content) -> some View {
        if phases.isEmpty {
            content
        } else {
            if let trigger {
                content
                    .phaseAnimator(phases, trigger: trigger, content: { view, phase in
                        view
                            .scaleEffect(phase.scale)
                            .rotationEffect(phase.angle)
                            .offset(x: phase.size.x, y: phase.size.y)
                    }, animation: { phase in
                        switch phase {
                        case .rotate(_):
                            return .easeInOut(duration: 0.8)
                        case .scale(let scale):
                            return .easeInOut(duration: 1/scale)
                        }
                    })
            } else {
                content
                    .phaseAnimator(phases, content: { view, phase in
                        view
                            .scaleEffect(phase.scale)
                            .rotationEffect(phase.angle)
                            .offset(x: phase.size.x, y: phase.size.y)
                    }, animation: { phase in
                        switch phase {
                        case .rotate(_):
                            return .linear(duration: 0.8)
                        case .scale(let scale):
                            return .linear(duration: 0.5/scale)
                        }
                    })
            }
        }
    }
}
public enum CardinalPoint: Double, CaseIterable {
    case north = 0
    case east = 90
    case south = 180
    case west = 270
    case north_360 = 360
    
    // SF Symbol (↗) is 45 degrees rotated, so we substract it to compensate
    public var angle: Angle { .degrees(self.rawValue) }
}
public enum PhaseAnimationType: Hashable {
    case scale(CGFloat)
    case rotate(CardinalPoint)
    
    var scale: CGFloat {
        switch self {
        case .scale(let value):
            return value
        default:
            return 1
        }
    }
    var angle: Angle {
        switch self {
        case .rotate(let value):
            return value.angle
        default:
            return .zero
        }
    }
    var size: (x: Double, y: Double) {
        switch self {
        default:
            return (0, 0)
        }
    }
}
public extension View {
    func phaseAnimation(_ phases: [PhaseAnimationType], _ trigger: String? = nil) -> some View {
        ModifiedContent(content: self, modifier: PhaseAnimationModifier(phases: phases, trigger: trigger))
    }
}
