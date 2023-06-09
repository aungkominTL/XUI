//
//  PreferenceKeys.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI

struct SaveBoundsPrefData: Equatable {
    let viewId: AnyHashable
    let bounds: CGRect
}

struct SaveSizePrefData: Equatable {
    let viewId: String
    let size: CGSize
}

struct SaveBoundsPrefKey: PreferenceKey {
    static var defaultValue: [SaveBoundsPrefData] = []
    static func reduce(value: inout [SaveBoundsPrefData], nextValue: () -> [SaveBoundsPrefData]) {
        value.append(contentsOf: nextValue())
    }
}

struct SaveSizePrefKey: PreferenceKey {
    static var defaultValue: [SaveSizePrefData]? = nil
    static func reduce(value: inout [SaveSizePrefData]?, nextValue: () -> [SaveSizePrefData]?) {
        guard let next = nextValue() else { return }
        value?.append(contentsOf: next)
    }
}


extension View {
    public func saveBounds(viewId: AnyHashable, coordinateSpace: CoordinateSpace = .global) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: SaveBoundsPrefKey.self, value: [SaveBoundsPrefData(viewId: viewId, bounds: proxy.frame(in: coordinateSpace))])
        })
    }

    public func retrieveBounds(viewId: AnyHashable, _ rect: Binding<CGRect>) -> some View {
        onPreferenceChange(SaveBoundsPrefKey.self) { preferences in
            let preference = preferences.first(where: { $0.viewId == viewId })
            if let preference {
                rect.wrappedValue = preference.bounds
            }
        }
    }
    public func retrieveBounds(viewId: AnyHashable, _ completion: @escaping (CGRect) -> Void) -> some View {
        onPreferenceChange(SaveBoundsPrefKey.self) { preferences in
            let preference = preferences.first(where: { $0.viewId == viewId })
            if let preference {
                completion(preference.bounds)
            }
        }
    }

    public func saveSize(viewId: String?, coordinateSpace: CoordinateSpace = .local) -> some View {
        Group {
            if let viewId = viewId {
                self.background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: SaveSizePrefKey.self, value: [SaveSizePrefData(viewId: viewId, size: proxy.size)])
                    }
                )
            } else {
                self
            }
        }
    }

    public func retrieveSize(viewId: String?, _ rect: Binding<CGSize?>) -> some View {
        Group {
            if let viewId = viewId {
                onPreferenceChange(SaveSizePrefKey.self) { preferences in
                    DispatchQueue.main.async {
                        guard let preferences = preferences else {
                            return
                        }
                        let p = preferences.first(where: { $0.viewId == viewId })
                        rect.wrappedValue = p?.size
                    }
                }
            } else {
                self
            }
        }
    }
}
