//
//  LibraryViewCell.swift
//  WHmusic
//
//  Created by airshiner on 10/6/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class LibraryViewCell: UITableViewCell {
    
    @IBOutlet weak var LibIconView: UIImageView!
    @IBOutlet weak var LibSongLabel: UILabel!
    @IBOutlet weak var LibSingerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}