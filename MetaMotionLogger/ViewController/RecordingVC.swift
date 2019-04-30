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
    @IBOutlet weak var batterLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MetaWearManager.sharedObject.delegate = self
        self.batterLevelLabel.text = String(format: "Battery Level: %d%%", MetaWearManager.sharedObject.batteryLevel)
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
    
    func receivedBattery(data: MetaWearBattery) {
        self.batterLevelLabel.text = String(format: "Battery Level: %d%%", data.charge)
    }
}
