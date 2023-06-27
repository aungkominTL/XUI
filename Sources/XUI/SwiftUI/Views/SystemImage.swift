//
//  SystemImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/6/23.
//

import SwiftUI
import SFSafeSyymbols

public enum SystemImageName: String, CaseIterable, Identifiable, Hashable {
    public var id: String { self.rawValue }
    case phone, message, envelope, calendar, eye, mappin, tram, heart, house, dollarsign, magnifyingglass, bookmark, map, toilet, washer, dishwasher, refrigerator, bus, tv, parkingsign, cross, cat, dog, seal, cart, storefront, pin, wifi, pumpup, info, exclamationmark, at, microwave, circle, checkmark
    case building_2_crop_cricle = "building.2.crop.circle"
    case bed_double_circle = "bed.double.circle"
    case hand_thumbsup = "hand.thumbsup"
    case mappin_and_ellipse = "mappin.and.ellipse"
    case person_crop = "person.crop"
    case bed_double = "bed.double"
    case air_conditioner_horizontal = "air.conditioner.horizontal"
    case frying_pan = "frying.pan"
    case chair_lounge = "chair.lounge"
    case fork_knife = "fork.knife"
    case square_and_arrow_up = "square.and.arrow.up"
    case square_and_arrow_down = "square.and.arrow.down"
    case figure_walk = "figure.walk.circle"
    case figure_pool_swim = "figure.pool.swim"
    case house_lodge = "house.lodge"

    public static var random: SystemImageName { Self.allCases.randomElement()! }
}

public struct SystemImage: View {

    private let sfSymbol: SFSymbol
    private let size: CGFloat?
    private var isRandomColor = false

    public init(_ _sfSymbol: SFSymbol, _ _size: CGFloat? = nil) {
        sfSymbol = _sfSymbol
        size = _size
    }
    
    public var body: some View {
        Image(systemName: sfSymbol.rawValue)
            .if_let(size) { value, view in
                view
                    .resizable()
                    .frame(square: value)
            }

            .if (isRandomColor) { view in
                view.foregroundColor(.random(seed: Array(repeating: sfSymbol.rawValue, count: 2).joined()))
            }
    }
    
    public func relativeColor(_ value: Bool = true) -> Self {
        map{ $0.isRandomColor = value }
    }
}
