//
//  WHLrcTool.swift
//  WHmusic
//
//  Created by airshiner on 9/29/16.
//  Copyright © 2016 airshiner. All rights reserved.
//

import UIKit

class WHLrcTool: NSObject {
    class func lrcToolWIthLrcName(lrcName: String) -> NSArray {
        let lrcPath = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil)
        let tempArr = NSMutableArray()
        do {
            let lrcString = try String(contentsOfFile: lrcPath!)
            let lrcArr = lrcString.componentsSeparatedByString("\n")
            for lrcLineString:NSString in lrcArr {
                if lrcLineString.hasPrefix("[ti:") || lrcLineString.hasPrefix("[ar") || lrcLineString.hasPrefix("[al:") || !lrcLineString.hasPrefix("[") {
                    continue
                }
                let lrcLine = WHLrcLine.lrcLineWithLrclingString(lrcLineString as String)
                tempArr.addObject(lrcLine)
            }
        }catch {
            print("Lrc run out!")
        }
        return tempArr
    }
}