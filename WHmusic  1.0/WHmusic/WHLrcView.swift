//
//  WHLrcView.swift
//  WHmusic
//
//  Created by airshiner on 9/28/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHLrcView: UIScrollView {
    private var _tableView = UITableView()
    private var lrcList = NSArray()
    private var currIndex:Int?
    var lrcLabel = WHLrcLabel()
    var duration:NSTimeInterval?
    var lrcName:String? {
        didSet {
            if let lrcText = lrcName {
                currIndex = 0
                lrcName = lrcText
                lrcList = WHLrcTool.lrcToolWIthLrcName(lrcName!)
                _tableView.reloadData()
            }
        }
    }
    var currentTime:NSTimeInterval? {
        didSet {
            if let currTimer = currentTime {
                if currentTime == 0 {
                    tableViewToScrillViewIndexPath()
                }
                currentTime = currTimer
                let count = lrcList.count
                for i in 0...count-1 {
                    let currentLine = lrcList[i] as! WHLrcLine
                    let nextIndex = i + 1
                    var nextLine:WHLrcLine?
                    if nextIndex < count {
                        nextLine = lrcList[nextIndex] as? WHLrcLine
                    }
                    if currIndex != i && currentTime >= currentLine.lrcTime && currentTime < nextLine?.lrcTime {
                        let indexPath = NSIndexPath(forRow: i, inSection: 0)
                        let previousIndexPath = NSIndexPath(forRow: currIndex!, inSection: 0)
                        currIndex = i
                        _tableView.reloadRowsAtIndexPaths([indexPath,previousIndexPath], withRowAnimation: .None)
                        _tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                        lrcLabel.text = currentLine.lrcText!
                        setupBackPlayImage()
                    }
                    if currIndex == i {
                        let indexPath = NSIndexPath(forRow: i, inSection:  0)
                        let cell = _tableView.cellForRowAtIndexPath(indexPath) as? WHLrcCell
                        let progress = (currentTime! - currentLine.lrcTime!) / ((nextLine?.lrcTime)! - currentLine.lrcTime!)
                        cell?._lrcLabel?.progress = CGFloat(progress)
                        lrcLabel.progress = CGFloat(progress)
                    }
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settingTableView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingTableView()
    }
    override func awakeFromNib() {
        settingTableView()
    }
}

extension WHLrcView {
    
    private func setupBackPlayImage() {
        
        let playingMusic = WHMusicTool.playerMusic()
        let currentImage = UIImage(named: playingMusic.icon!)
        let currLrc = lrcList[currIndex!] as! WHLrcLine
        
        let previousIndex = currIndex! - 1
        var previousLrc: WHLrcLine?
        if previousIndex >= 0 {
            previousLrc = lrcList[previousIndex] as? WHLrcLine
        }
        
        let nextIndex = currIndex! + 1
        var nextLrc = WHLrcLine()
        if nextIndex < lrcList.count {
            nextLrc = lrcList[nextIndex] as! WHLrcLine
        }
        
        let lockImage = currentImage?.setImageWithString(25.0, currText: currLrc.lrcText!, preText: previousLrc?.lrcText, nextText: nextLrc.lrcText!)
        
        WHBackPlayTool.setupLockScreenInfoWithLockImage(lockImage!, duration: duration!, currTime: currentTime!)
    }
}

extension WHLrcView: UITableViewDataSource {
    @objc internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcList.count
    }
    @objc internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = WHLrcCell.lrcCellWithTableView(tableView)
        if (currIndex == indexPath.row) {
            cell._lrcLabel?.font = UIFont.systemFontOfSize(17)
        }else {
            cell._lrcLabel?.font = UIFont.systemFontOfSize(15)
            cell._lrcLabel?.progress = 0
        }
        let lrcline = lrcList[indexPath.row] as! WHLrcLine
        cell._lrcLabel?.text = lrcline.lrcText
        return cell;
    }
}

extension WHLrcView {
    private func settingTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.rowHeight = 35
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        _tableView = tableView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let lrcViewVVFL = "V:|-0-[lrcView(==hScrollView)]-0-|";
        let lrcViewVCons = NSLayoutConstraint.constraintsWithVisualFormat(lrcViewVVFL, options: .DirectionLeadingToTrailing, metrics: nil, views: ["lrcView" : _tableView,"hScrollView" : self])
        addConstraints(lrcViewVCons)
        
        let lrvViewWidthCon = NSLayoutConstraint(item: _tableView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0)
        let lrvViewRightCon = NSLayoutConstraint(item: _tableView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
        let lrcViewLeftCon  = NSLayoutConstraint(item: _tableView, attribute: .Left , relatedBy: .Equal, toItem: self, attribute:  .Left, multiplier: 1.0, constant: self.bounds.width)
        addConstraint(lrcViewLeftCon)
        addConstraint(lrvViewRightCon)
        addConstraint(lrvViewWidthCon)
        
        _tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0)
        tableViewToScrillViewIndexPath()
    }
    
    private func tableViewToScrillViewIndexPath() {
        let indexPath = NSIndexPath(forRow: currIndex!, inSection: 0)
        _tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
}