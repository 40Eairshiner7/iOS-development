//
//  WHMusicExtens.swift
//  WHmusic
//
//  Created by airshiner on 10/5/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

extension CALayer {
    func pauseAnimate() {
        let pausedTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    func resumeAnimate() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), toLayer: nil) - pausedTime
        beginTime = timeSincePause
    }
}

extension UIImage {
    func setImageWithString(titleH: CGFloat, currText: NSString, preText: NSString?, nextText: NSString?) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let style = NSMutableParagraphStyle()
        style.alignment = .Center
        
        let currTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(19),
            NSForegroundColorAttributeName: UIColor(red: 38/225.0, green: 187/255.0, blue: 102/255.0, alpha: 1.0),
            NSParagraphStyleAttributeName: style
        ]
        
        let otherTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSParagraphStyleAttributeName: style
        ]
        
        currText.drawInRect(CGRectMake(0, size.height - (titleH * 2), size.width, size.height), withAttributes: currTextAttributes)
        
        preText!.drawInRect(CGRectMake(0, size.height - (titleH * 3), size.width, size.height), withAttributes: otherTextAttributes)
        nextText!.drawInRect(CGRectMake(0, size.height - titleH, size.width, size.height), withAttributes: otherTextAttributes)
        
        let textImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return textImage
    }
}
