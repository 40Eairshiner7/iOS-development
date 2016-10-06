//
//  ViewController.swift
//  WHmusic
//
//  Created by airshiner on 9/27/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit
import AVFoundation

class WHMusicController: UIViewController {
    
    @IBOutlet weak var SongLabel: UILabel!
    @IBOutlet weak var SingerLabel: UILabel!
    @IBOutlet weak var SliderView: UISlider!
    @IBOutlet weak var MinTimeLabel: UILabel!
    @IBOutlet weak var MaxTimeLabel: UILabel!
    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var IconView: UIView!
    @IBOutlet weak var LrcLabel: WHLrcLabel!
    @IBOutlet weak var BackGroundView: UIImageView!
    private var currentSong = AVAudioPlayer()
    private var SliderProgressTimer:NSTimer?
    private var lrcTimer:CADisplayLink?
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var LrcView: WHLrcView!
    
    var trackId:WHMusic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingPlaySong()
        LrcView.lrcLabel = LrcLabel
    }
}

extension WHMusicController {
    private func addSliedTimer() {
        updateMuneInfo()
        SliderProgressTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: #selector(WHMusicController.updateMuneInfo), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(SliderProgressTimer!, forMode: NSRunLoopCommonModes)
    }
    
    private func removeSliderTimer() {
        SliderProgressTimer?.invalidate()
        SliderProgressTimer = nil
    }
    
    @objc private func updateMuneInfo() {
        MinTimeLabel.text = NSString.stringWithTime(currentSong.currentTime)
        SliderView.value = Float(currentSong.currentTime / currentSong.duration)
    }
    
    @IBAction func startSlider() {
        removeSliderTimer()
    }
    
    @IBAction func sliderValueChange() {
        MinTimeLabel.text = NSString.stringWithTime(currentSong.duration * Double(SliderView.value))
    }
    
    @IBAction func endSlider() {
        currentSong.currentTime = currentSong.duration * Double(SliderView.value)
        addSliedTimer()
    }
    
    @objc private func sliderClick(tap: UITapGestureRecognizer) {
        let point = tap.locationInView(SliderView)
        let ratio = point.x / SliderView.bounds.size.width
        currentSong.currentTime = Double(ratio) * currentSong.duration
        updateMuneInfo()
    }
    
    private func addLrcTimer() {
        lrcTimer = CADisplayLink(target: self, selector: #selector(WHMusicController.updateLrcTimer))
        lrcTimer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    private func removeLrcTimer() {
        lrcTimer?.invalidate()
        lrcTimer = nil
    }
    
    @objc private func updateLrcTimer() {
        LrcView.currentTime = currentSong.currentTime;
    }
}

extension WHMusicController {
    
    @IBAction func preSong() {
        let previousMusic = WHMusicTool.previousMusic()
        playMusicWithMusic(previousMusic)
    }
    
    @IBAction func playSong() {
        PlayButton.selected = !PlayButton.selected
        if currentSong.playing {
            currentSong.pause()
            removeSliderTimer()
            removeLrcTimer()
            IconImageView.layer.pauseAnimate()
        }else {
            currentSong.play()
            addSliedTimer()
            removeLrcTimer()
            IconImageView.layer.resumeAnimate()
        }
    }
    
    @IBAction func nextSong() {
        let nextMusic = WHMusicTool.nextMusic()
        playMusicWithMusic(nextMusic)
    }
    
    private func playMusicWithMusic(music: WHMusic) {
        trackId = music
        let playerMusic = WHMusicTool.playerMusic()
        WHAudioTool.stopMusicWithMusicName(playerMusic.filename!)
        LrcLabel.text = ""
        LrcView.currentTime = 0
        WHAudioTool.playMusicWithMusicName(music.filename!)
        WHMusicTool.setPlayingMusic(music)
        settingPlaySong()
    }
    
    private func settingPlaySong() {
        
        let playerMusic = WHMusicTool.playerMusic()
        WHAudioTool.stopMusicWithMusicName(playerMusic.filename!)
        
        let currentMusic = trackId!
        let currentAudio = WHAudioTool.playMusicWithMusicName(currentMusic.filename!)
        
        BackGroundView.image = UIImage(named: currentMusic.icon!)
        IconImageView.image = UIImage(named: currentMusic.icon!)
        SongLabel.text = currentMusic.name
        SingerLabel.text = currentMusic.singer
        currentAudio.delegate = self
        
        MinTimeLabel.text = NSString.stringWithTime(currentAudio.currentTime)
        MaxTimeLabel.text = NSString.stringWithTime(currentAudio.duration)
        currentSong = currentAudio
        
        PlayButton.selected = currentSong.playing
        SliderView.value = 0
        
        LrcView.lrcName = currentMusic.lrcname;
        LrcView.duration = currentSong.duration;
        LrcLabel.text = ""
        
        removeSliderTimer()
        addSliedTimer()
        removeLrcTimer()
        addLrcTimer()
        startIconViewAnimate()
    }
}

extension WHMusicController: AVAudioPlayerDelegate,UIScrollViewDelegate {
    @objc internal func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextSong()
        }
    }
    
    @objc internal func scrollViewDidScroll(scrollView: UIScrollView) {
        let point = scrollView.contentOffset;
        let ratio = 1 - point.x / scrollView.bounds.size.width;
        IconView.alpha = ratio
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch (event!.subtype) {
        case .RemoteControlPlay:
            playSong()
        case .RemoteControlPause:
            playSong()
        case .RemoteControlNextTrack:
            nextSong()
        case .RemoteControlPreviousTrack:
            preSong()
        default:
            break
        }
    }
}

extension WHMusicController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        IconImageView.layer.cornerRadius = IconImageView.bounds.width * 0.5
        IconImageView.layer.masksToBounds = true
        IconImageView.layer.borderWidth = 8
        IconImageView.layer.borderColor = UIColor(red: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.0).CGColor
        
        SliderView.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
        LrcView.contentSize = CGSizeMake(view.bounds.width * 2, 0)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func startIconViewAnimate() {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = 2 * M_PI
        rotateAnim.repeatCount = Float(NSIntegerMax)
        rotateAnim.duration = 15
        
        IconImageView.layer.addAnimation(rotateAnim, forKey: nil)
        
        let tapSlider = UITapGestureRecognizer()
        tapSlider.addTarget(self, action: #selector(WHMusicController.sliderClick(_:)))
        SliderView.addGestureRecognizer(tapSlider)
    }
}
