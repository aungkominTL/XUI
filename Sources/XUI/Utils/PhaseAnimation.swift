//
//  PhaseAnimation.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/5/24.
//

import SwiftUI

private struct PhaseAnimationModifier: ViewModifier {
    let phases: [PhaseAnimationType]
    let trigger: Bool?
    func body(content: Content) -> some View {
        if let trigger {
            if #available(iOS 17.0, *) {
                content
                    .phaseAnimator(phases, trigger: trigger) { view, phase in
                        view
                            .scaleEffect(phase.scale)
                            .rotationEffect(phase.angle)
                            .offset(x: phase.size.x, y: phase.size.y)
                    }
            } else {
                content
            }
        } else {
            if #available(iOS 17.0, *) {
                content
                    .phaseAnimator(phases) { view, phase in
                        view
                            .scaleEffect(phase.scale)
                            .rotationEffect(phase.angle)
                    }
            } else {
                content
            }
        }
    }
}

public enum PhaseAnimationType: Hashable {
    case idle
    case scale(CGFloat)
    case rotate(Double)
    case transition(x: Double, y: Double)
    
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
            return .degrees(value)
        default:
            return .zero
        }
    }
    var size: (x: Double, y: Double) {
        switch self {
        case .transition(let value):
            return value
        default:
            return (0, 0)
        }
    }
}
public extension View {
    func phaseAnimation(_ phases: [PhaseAnimationType], _ trigger: Bool? = nil) -> some View {
        ModifiedContent(content: self, modifier: PhaseAnimationModifier(phases: phases, trigger: trigger))
    }
}
