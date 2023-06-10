//
//  SystemImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/6/23.
//

import SwiftUI

public enum SystemImageName: String {
    case phone, message, envelope, calendar, eye, mappin, tram
    case building_2_crop_cricle = "building.2.crop.circle"
}

public struct SystemImage: View {

    private let imageName: SystemImageName
    private let size: CGFloat?

    public init(_ imageName: SystemImageName, _ size: CGFloat? = nil) {
        self.imageName = imageName
        self.size = size
    }
    
    public var body: some View {
        Image(systemName: imageName.rawValue)
            .if_let(size) { value, view in
                view
                    .resizable()
                    .frame(square: value)
            }
    }
}
