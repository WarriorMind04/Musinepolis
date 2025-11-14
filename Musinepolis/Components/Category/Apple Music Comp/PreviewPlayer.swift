//
//  PreviewPlayer.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 14/11/25.
//

import Foundation
import AVFoundation

class PreviewPlayer {
    static let shared = PreviewPlayer()
    private var player: AVPlayer?

    func playPreview(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }

    func stop() {
        player?.pause()
    }
}
