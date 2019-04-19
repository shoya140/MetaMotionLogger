//
//  FileWriter.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

class FileWriter: NSObject {
    
    static let sharedWriter = FileWriter()
    var isRecording = false
    var segmentLabel:Int = 0
    
    private var fileHandle: FileHandle?
    private var dateFormatter: DateFormatter!
    private let kISO8601Format: String = "yyyy-MM-dd_HH-mm-ss"
    
    override init() {
        super.init()
        
        // create date formatter
        dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = kISO8601Format
    }
    
    func startRecording() {
        self.isRecording = true
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let currentFilePrefix = dateFormatter.string(from: NSDate() as Date)
        
        let filePath = documentDirectory + "/" + currentFilePrefix + ".csv"
        let text = "timestamp,type,value1,value2,value3,segment\n"
        do {
            try text.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
        fileHandle = FileHandle(forWritingAtPath: filePath)
        fileHandle?.seekToEndOfFile()
        
    }
    
    func stopRecording() {
        fileHandle?.closeFile()
        fileHandle = nil
        self.isRecording = false
    }
    
    func write(data: String) {
        if !self.isRecording {
            return
        }
        
        if let handle = fileHandle {
            if let d = (NSDate().timeIntervalSince1970.description+","+data+","+segmentLabel.description+"\n").data(using: String.Encoding.utf8) {
                handle.write(d)
            }
        }
    }
    
}
