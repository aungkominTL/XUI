//
//  AttachmentViewerView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/7/23.
//

import SwiftUI

public struct AttachmentViewerView: View {
    
    private let attachment: XAttachment
    @State private var loadedImage: Image?
    
    public init(_ attachment: XAttachment) {
        self.attachment = attachment
    }
    
    public var body: some View {
        Group {
            switch attachment.type {
            case .photo:
                ZoomableScrollView {
                    ZStack {
                        Color.black
                        AsyncImage(url: attachment._url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .onAppear {
                                        loadedImage = image
                                    }
                            case .failure(let error):
                                ErrorView(error: error) {}
                            @unknown default:
                                fatalError()
                            }
                        }
                    }
                }
            case .video:
                if let url = attachment._url {
                    MediaPlayerView(url: url)
                }
            }
        }
        .navigationBarItems(trailing: shareButton)
    }
    
    @ViewBuilder private var shareButton: some View {
        if let loadedImage {
            ShareLink(item: loadedImage, preview: SharePreview(attachment.type.rawValue, icon: loadedImage))
        } else if let url = attachment._url {
            ShareLink(item: url, preview: SharePreview(attachment.id))
        }
    }
}
