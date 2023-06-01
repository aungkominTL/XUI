//
//  File.swift
//  
//
//  Created by Aung Ko Min on 10/5/23.
//

import SwiftUI

public enum DragDirection: Hashable {

    case left, right, up, down

    @available(iOS 13.0, *)
    func isValid(value: DragGesture.Value, distance: CGFloat) -> Bool {
        switch self {
        case .left:
            return value.startLocation.x - value.location.x > distance
        case .right:
            return value.location.x - value.startLocation.x > distance
        case .up:
            return value.startLocation.y - value.location.y > distance
        case .down:
            return value.location.y - value.startLocation.y > distance
        }
    }
}

@available(iOS 13.0.0, *)
private struct _OnDragModifier: ViewModifier {

    let direction: DragDirection
    let distance: CGFloat
    let perform: () -> Void
    @State private var offset = CGPoint.zero

    public func body(content: Content) -> some View {
        content
            .transformEffect(.init(translationX: offset.x, y: offset.y))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if direction.isValid(value: value, distance: 10) {
                            switch direction {
                            case .left:
                                offset.x = value.startLocation.x - value.location.x
                            case .right:
                                offset.x = value.startLocation.x - value.location.x
                            case .up:
                                offset.y = value.location.y - value.startLocation.y
                            case .down:
                                offset.y = value.location.y - value.startLocation.y
                            }
                        }
                    }
                    .onEnded(handleDrag(_:))
            )
    }

    private func handleDrag(_ value: DragGesture.Value) {
        offset = .zero
        if direction.isValid(value: value, distance: distance) {
            _Haptics.shared.play(.soft)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: perform)
        }
    }
}

@available(iOS 13.0.0, *)
public extension View {
    func _onDrag(_ direction: DragDirection, _ distance: CGFloat = 100, _ perform: @escaping () -> Void) -> some View {
        modifier(_OnDragModifier(direction: direction, distance: distance, perform: perform))
    }
}

