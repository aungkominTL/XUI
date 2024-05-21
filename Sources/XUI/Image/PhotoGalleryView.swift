//
//  PhotoGalleryView.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import SwiftUI

public struct PhotoGalleryView: View {
    
    private var attachments: [XAttachment]
    @Binding private var selection: Int
    private let title: String
    
    public init(attachments: [XAttachment], title: String, selection: Binding<Int>) {
        self.attachments = attachments
        self.title = title
        self._selection = selection
    }
    
    public var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ForEach(Array(attachments.enumerated()), id: \.offset) { (index, item) in
                    AttachmentViewerView(item)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                XPhotoPageControl(selection: $selection, length: attachments.count, size: 13)
            }
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(leading: _DismissButton())
            .tint(Color.white)
        }
        .colorScheme(.dark)
        .statusBarHidden(true)
    }
    
}
