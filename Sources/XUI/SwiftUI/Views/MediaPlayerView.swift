//
//  MediaPlayerView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 30/1/23.
//

import SwiftUI
import AVKit

public struct MediaPlayerView: View {

    private let player: AVPlayer

    public init(url: URL) {
        player = AVPlayer(url: url)
    }

    public var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onAppear{
                player.play()
            }
            .navigationBarItems(trailing: _DismissButton())
    }
}
