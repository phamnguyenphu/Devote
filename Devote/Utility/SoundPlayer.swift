//
//  SoundPlayer.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 14/04/2023.
//

import AVFoundation
import Foundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        }
        catch {
            print("Could not find and play the sound file")
        }
    }
}
