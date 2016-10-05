//
//  WHAudioTool.swift
//  WHmusic
//
//  Created by airshiner on 9/28/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit
import AVFoundation

class WHAudioTool {
    static var playSongs = NSMutableDictionary()
    class func playMusicWithMusicName(musicName:String) -> AVAudioPlayer {
        
        var audioPlayer:AVAudioPlayer?
        audioPlayer = playSongs[musicName] as? AVAudioPlayer
        
        if audioPlayer == nil {
            let fileUrl = NSBundle.mainBundle().URLForResource(musicName, withExtension: nil)
            if fileUrl != nil {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOfURL: fileUrl!)
                    playSongs.setObject(audioPlayer!, forKey: musicName)
                    audioPlayer?.prepareToPlay()
                }catch {
                    print("get url failed!")
                }
            }
        }
        audioPlayer!.play()
        return audioPlayer!
    }
    class func pauseMusicWithMusicName(musicName:String) {
        let player = playSongs[musicName]
        
        if (player != nil) {
            player?.pause()
        }
    }
    class func stopMusicWithMusicName(musicName:String) {
        var player = playSongs[musicName]
        
        if (player != nil) {
            player!.player
            playSongs.removeObjectForKey(musicName)
            player = nil
        }
    }
}