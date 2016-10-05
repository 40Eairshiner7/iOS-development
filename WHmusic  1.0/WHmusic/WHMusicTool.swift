//
//  WHMusicTool.swift
//  WHmusic
//
//  Created by airshiner on 9/28/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHMusicTool: NSObject {
    
    static var _music:NSArray?
    static var _playingMusic:WHMusic?
    
    override class func initialize() {
        if _music == nil {
            let urlPath = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil)
            let songList = NSArray(contentsOfFile: urlPath!)
            let musicArray = NSMutableArray()
            for musicDict in songList! {
                let music = WHMusic()
                music.setValuesForKeysWithDictionary(musicDict as! [String : AnyObject])
                musicArray.addObject(music)
            }
            _music = musicArray
        }
        if _playingMusic == nil {
            _playingMusic = _music![5] as? WHMusic
        }
    }
}

extension WHMusicTool {
    class func playerMusic() -> WHMusic {
        return _playingMusic!
    }
    class func setPlayingMusic(playingMusic: WHMusic) {
        _playingMusic = playingMusic
    }
    class func nextMusic() ->WHMusic {
        var currentIndex = _music?.indexOfObject(_playingMusic!)
        var nextIndex = currentIndex!+1
        currentIndex!+=1;
        if nextIndex >= _music!.count {
            nextIndex = 0
        }
        let nextMusic = _music![nextIndex] as! WHMusic
        return nextMusic
    }
    class func previousMusic() -> WHMusic {
        var currentIndex = _music?.indexOfObject(_playingMusic!)
        var previousIndex = currentIndex!-1
        currentIndex!-=1;
        if previousIndex < 0 {
            previousIndex = _music!.count - 1
        }
        let previousMusic = _music![previousIndex] as! WHMusic
        return previousMusic
    }
}
