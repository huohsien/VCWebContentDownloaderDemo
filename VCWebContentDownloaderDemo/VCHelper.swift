//
//  VCHelper.swift
//  VCWebContentDownloaderDemo
//
//  Created by victor on 30/05/2017.
//  Copyright © 2017 VHHC Studio. All rights reserved.
//

import UIKit
import CocoaLumberjack

class VCHelper: NSObject {

    class func readTextFrom(file: String) -> String? {
        
        var text : String?
        text = nil
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //reading
            do {
                text = try String(contentsOf: path, encoding: String.Encoding.utf8)
            }
            catch {
                DDLogError("error occured while reading text from the file")
                return nil
            }
        }
        return text
    }
    
    class func writeTo(file : String , text :  String?) {
        
        if text == nil {
            return
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text?.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                DDLogError("error occured while writing text to the file")
            }
            
        }
    }

}
