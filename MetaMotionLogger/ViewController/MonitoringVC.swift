//
//  MonitoringVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

class MonitoringVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MetaWearManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var numberOfValuesToBeDisplayed100Hz: UInt = 800
    private var numberOfValuesToBeDisplayed10Hz: UInt = 80
    private var accXValues: [Double] = [0.0]
    private var accYValues: [Double] = [0.0]
    private var accZValues: [Double] = [0.0]
    private var rollValues: [Double] = [0.0]
    private var pitchValues: [Double] = [0.0]
    private var yawValues: [Double] = [0.0]
    private var magXValues: [Double] = [0.0]
    private var magYValues: [Double] = [0.0]
    private var magZValues: [Double] = [0.0]
    private var quatWValues: [Double] = [0.0]
    private var quatXValues: [Double] = [0.0]
    private var quatYValues: [Double] = [0.0]
    private var quatZValues: [Double] = [0.0]
    
    private var sampleCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MetaWearManager.sharedObject.delegate = self
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (Timer) in
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "BMI160"
        default:
            return "BOSCH Sensor Fusion"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Accelerometer"
                (cell.viewWithTag(2) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(2) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(2) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(2) as! SIGraphView).signals = [accXValues, accYValues, accZValues]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Gyroscope"
                (cell.viewWithTag(2) as! SIGraphView).maximumValue = 1000
                (cell.viewWithTag(2) as! SIGraphView).minimumValue = -1000
                (cell.viewWithTag(2) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(2) as! SIGraphView).signals = [rollValues, pitchValues, yawValues]
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
            (cell.viewWithTag(1) as! UILabel).text = "Quaternion"
            (cell.viewWithTag(2) as! SIGraphView).maximumValue = 1
            (cell.viewWithTag(2) as! SIGraphView).minimumValue = -1
            (cell.viewWithTag(2) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
            (cell.viewWithTag(2) as! SIGraphView).signals = [quatWValues, quatXValues, quatYValues, quatZValues,]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    func receivedAcc(data: MetaWearAcc) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "acc,%f,%f,%f", data.x, data.y, data.z) as String)
        }
        
        accXValues.append(data.x)
        if accXValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accXValues.removeSubrange(0 ..< accXValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        accYValues.append(data.y)
        if accYValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accYValues.removeSubrange(0 ..< accYValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        accZValues.append(data.z)
        if accZValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accZValues.removeSubrange(0 ..< accZValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
    }
    
    func receivedGyro(data: MetaWearGyro) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "gyro,%f,%f,%f,", data.roll, data.pitch, data.yaw) as String)
        }
        
        rollValues.append(data.roll)
        if rollValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            rollValues.removeSubrange(0 ..< rollValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        pitchValues.append(data.pitch)
        if pitchValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            pitchValues.removeSubrange(0 ..< pitchValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        yawValues.append(data.yaw)
        if yawValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            yawValues.removeSubrange(0 ..< yawValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
    }
    
    func receivedMag(data: MetaWearMag) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "mag,%f,%f,%f,", data.x, data.y, data.z) as String)
        }
    }
    
    func receivedQuat(data: MetaWearQuat) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "quat,%f,%f,%f,%f", data.w, data.x, data.y, data.z) as String)
        }
        
        quatWValues.append(data.w)
        if quatWValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatWValues.removeSubrange(0 ..< quatWValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        quatXValues.append(data.x)
        if quatXValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatXValues.removeSubrange(0 ..< quatXValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        quatYValues.append(data.y)
        if quatYValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatYValues.removeSubrange(0 ..< quatYValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
        
        quatZValues.append(data.z)
        if quatZValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatZValues.removeSubrange(0 ..< quatZValues.count - Int(numberOfValuesToBeDisplayed100Hz))
        }
    }
    
}
