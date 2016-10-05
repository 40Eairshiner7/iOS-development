//
//  WHLrcCell.swift
//  WHmusic
//
//  Created by airshiner on 9/29/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHLrcCell: UITableViewCell {
    var _lrcLabel:WHLrcLabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let lrcLabel = WHLrcLabel()
        lrcLabel.textColor = UIColor.whiteColor()
        lrcLabel.font = UIFont.systemFontOfSize(15)
        lrcLabel.textAlignment = .Center
        contentView.addSubview(lrcLabel)
        _lrcLabel = lrcLabel
        lrcLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelHcon = NSLayoutConstraint(item: lrcLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let labelVcon = NSLayoutConstraint(item: lrcLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0)
        addConstraint(labelHcon)
        addConstraint(labelVcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func lrcCellWithTableView(tableView:UITableView) -> WHLrcCell {
        let ID = "LrcCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? WHLrcCell
        if cell == nil {
            cell = WHLrcCell(style: .Default, reuseIdentifier:  ID)
            cell!.backgroundColor = UIColor.clearColor()
            cell!.selectionStyle = .None
        }
        return cell!
    }
    
}