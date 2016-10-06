//
//  LibraryTableView.swift
//  WHmusic
//
//  Created by airshiner on 10/6/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    var musicArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlPath = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil)
        let songList = NSArray(contentsOfFile: urlPath!)
        musicArray = NSMutableArray()
        for musicDict in songList! {
            let music = WHMusic()
            music.setValuesForKeysWithDictionary(musicDict as! [String : AnyObject])
            musicArray!.addObject(music)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("musicCell", forIndexPath: indexPath) as! LibraryViewCell
        
        let Music = musicArray![indexPath.row] as! WHMusic
        cell.LibSongLabel.text = Music.name
        cell.LibSingerLabel.text = Music.singer
        
        if let coverImage = Music.singerIcon {
            cell.LibIconView.image = UIImage(named: "\(coverImage)")
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlayer" {

            let playerVC = segue.destinationViewController as! WHMusicController
            let indexPath = tableView.indexPathForSelectedRow!
            playerVC.trackId = musicArray![indexPath.row] as! WHMusic

        }
    }
    
}