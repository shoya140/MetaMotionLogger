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
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    
    private var label:Int = 0
    
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
            self.segmentSwitch.selectedSegmentIndex = 0
        }
    }
    @IBAction func eventLabelButtonTapped(_ sender: Any) {
        FileWriter.sharedWriter.write(data: "label,1")
    }
    
    @IBAction func segmentLabelChanged(_ sender: Any) {
        FileWriter.sharedWriter.segmentLabel = (sender as AnyObject).selectedSegmentIndex
    }
    
    // MARK: - Meta wear manager delegate
    
    func accDataReceived(data: [String : Double]) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "acc,%f,%f,%f", data["x"]!, data["y"]!, data["z"]!) as String)
        }
    }
    
    func gyroDataReceived(data: [String : Double]) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "gyro,%f,%f,%f", data["roll"]!, data["pitch"]!, data["yaw"]!) as String)
        }
    }
}
