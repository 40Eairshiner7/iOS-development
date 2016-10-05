//
//  WHLrcLine.swift
//  WHmusic
//
//  Created by airshiner on 9/29/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHLrcLine: NSObject {
    var lrcText: String?
    var lrcTime: NSTimeInterval?
    
    private func initWithLrclingString(lrcText: String) ->WHLrcLine {
        
        let lrcLine = WHLrcLine()
        let lrcArr = lrcText.componentsSeparatedByString("]")
        let timeString:NSString = lrcArr[0]
        lrcLine.lrcTime = NSString.timeStringWithString(timeString.substringFromIndex(1))
        lrcLine.lrcText = lrcArr[1]
        
        return lrcLine
    }
    
    class func lrcLineWithLrclingString(LrcText: String) -> WHLrcLine {
        let lrcLine = WHLrcLine()
        return lrcLine.initWithLrclingString(LrcText)
    }
    
}

extension NSString {
    
    class func stringWithTime(time: NSTimeInterval) -> String {
        let minutes = time / 60
        let sec = time % 60
        return String(format: "%02.f:%02.f" ,minutes,sec)
    }
    
    class func timeStringWithString(timeString: NSString) -> NSTimeInterval {
        let minutes = Double(timeString.componentsSeparatedByString(":")[0])
        let sec = Double(timeString.substringWithRange(NSMakeRange(3, 2)))
        let msc = Double(timeString.componentsSeparatedByString(".")[1])
        return (minutes! * 60 + sec! + msc! * 0.01)
    }
    
}