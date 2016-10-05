//
//  WHBackPlayTool.swift
//  WHmusic
//
//  Created by airshiner on 10/5/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class WHBackPlayTool: NSObject {
    
    class func setupBackPlay() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(true)
    }
    
    class func setupLockScreenInfoWithLockImage(lockImage: UIImage, duration: NSTimeInterval, currTime: NSTimeInterval) {
        let playingMusic = WHMusicTool.playerMusic()
        let playingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
        let artWord = MPMediaItemArtwork(image: lockImage)
        
        let playingInfo = [
            MPMediaItemPropertyAlbumTitle: playingMusic.name!,
            MPMediaItemPropertyAlbumArtist: playingMusic.singer!,
            MPMediaItemPropertyArtwork: artWord,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currTime
        ]
        
        playingInfoCenter.nowPlayingInfo = playingInfo
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
}
