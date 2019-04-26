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
    var labelCount:Int = 0
    
    private var fileHandle: FileHandle?
    private var dateFormatter: DateFormatter!
    private var textBuffer: [String]?
    
    override init() {
        super.init()
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    }
    
    func startRecording() {
        self.textBuffer = []
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let now = NSDate()
        let datetimeString = dateFormatter.string(from: now as Date)
        
        let filePath = documentDirectory + "/" + datetimeString + ".csv"
        let text = "type,value1,value2,value3,value4\n"
        do {
            try text.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
        fileHandle = FileHandle(forWritingAtPath: filePath)
        fileHandle?.seekToEndOfFile()
        
        self.isRecording = true
        self.writeLabel(data: "start")
    }
    
    func stopRecording() {
        self.writeLabel(data: "stop")
        
        if let handle = fileHandle, let b = textBuffer {
            if b.count > 0 {
                if let d = (b.joined().data(using: String.Encoding.utf8)) {
                    handle.write(d)
                }
            }
        }
        
        self.isRecording = false
        
        fileHandle?.closeFile()
        fileHandle = nil
        self.textBuffer = nil
    }
    
    func write(data: String) {
        if !self.isRecording {
            return
        }
        
        textBuffer!.append(data)
        if textBuffer?.count == 1000 {
            if let handle = fileHandle, let b = textBuffer {
                if let d = (b.joined().data(using: String.Encoding.utf8)) {
                    handle.write(d)
                }
            }
            textBuffer = []
        }
    }
    
    func writeLabel(data: String) {
        labelCount += 1
        let now = NSDate()
        let datetimeString = dateFormatter.string(from: now as Date)
        FileWriter.sharedWriter.write(data: "label,"+now.timeIntervalSince1970.description+","+datetimeString+","+String(labelCount)+","+data+"\n")
    }
    
}
