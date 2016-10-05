//
//  WHLrcLabel.swift
//  WHmusic
//
//  Created by airshiner on 9/28/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHLrcLabel: UILabel {
    var progress:CGFloat? = 0 {
        didSet {
            if let iProgress = progress {
                progress = iProgress
                setNeedsDisplay()
            }
        }
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let fillRect = CGRectMake(0, 0, bounds.size.width * progress!, bounds.size.height)
        UIColor(red: 38/255.0, green: 187/255.0, blue: 102/255.0, alpha: 1.0).set()
        UIRectFillUsingBlendMode(fillRect, .SourceIn)
    }
}
