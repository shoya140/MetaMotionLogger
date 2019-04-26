//
//  RecordingVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

class RecordingVC: UIViewController, MetaWearManagerDelegate {
    
    @IBOutlet weak var recordSwitchButton: SIFlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MetaWearManager.sharedObject.delegate = self
    }
    
    @IBAction func switchRecording(_ sender: Any) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.stopRecording()
            self.recordSwitchButton.setTitle("Start Recording", for: [])
            self.recordSwitchButton.inverse = false
        } else {
            if MetaWearManager.sharedObject.device == nil {
                return
            }
            FileWriter.sharedWriter.startRecording()
            self.recordSwitchButton.setTitle("Stop Recording", for: [])
            self.recordSwitchButton.inverse = true
        }
    }
    @IBAction func eventLabelButtonTapped(_ sender: Any) {
        FileWriter.sharedWriter.writeLabel(data: "")
    }
    
    // MARK: - Meta wear manager delegate
    
    func receivedAcc(data: MetaWearAcc) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "acc,%f,%f,%f,\n", data.x, data.y, data.z) as String)
        }
    }
    
    func receivedGyro(data: MetaWearGyro) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "gyro,%f,%f,%f,\n", data.roll, data.pitch, data.yaw) as String)
        }
    }
    
    func receivedMag(data: MetaWearMag) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "mag,%f,%f,%f,\n", data.x, data.y, data.z) as String)
        }
    }
    
    func receivedQuat(data: MetaWearQuat) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "quat,%f,%f,%f,%f\n", data.w, data.x, data.y, data.z) as String)
        }
    }
}
