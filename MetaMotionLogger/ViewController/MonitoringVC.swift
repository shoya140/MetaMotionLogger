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
    
    private var numberOfValuesToBeDisplayed: UInt = 800
    private var accXValues: [Double] = [0.0]
    private var accYValues: [Double] = [0.0]
    private var accZValues: [Double] = [0.0]
    private var rollValues: [Double] = [0.0]
    private var pitchValues: [Double] = [0.0]
    private var yawValues: [Double] = [0.0]
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Accelerometer"
        case 1:
            return "Gyroscope"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "X"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", accXValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = accXValues
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Y"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", accYValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = accYValues
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Z"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", accZValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = accZValues
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "X"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", rollValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = rollValues
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Y"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", pitchValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = pitchValues
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Z"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.3f", yawValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed
                (cell.viewWithTag(3) as! SIGraphView).values = yawValues
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                return cell
            }
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
        if accXValues.count > Int(self.numberOfValuesToBeDisplayed) {
            accXValues.removeSubrange(0 ..< accXValues.count - Int(numberOfValuesToBeDisplayed))
        }
        
        accYValues.append(data.y)
        if accYValues.count > Int(self.numberOfValuesToBeDisplayed) {
            accYValues.removeSubrange(0 ..< accYValues.count - Int(numberOfValuesToBeDisplayed))
        }
        
        accZValues.append(data.z)
        if accZValues.count > Int(self.numberOfValuesToBeDisplayed) {
            accZValues.removeSubrange(0 ..< accZValues.count - Int(numberOfValuesToBeDisplayed))
        }
    }
    
    func receivedGyro(data: MetaWearGyro) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.write(data: NSString(format: "gyro,%f,%f,%f", data.roll, data.pitch, data.yaw) as String)
        }
        
        rollValues.append(data.roll)
        if rollValues.count > Int(self.numberOfValuesToBeDisplayed) {
            rollValues.removeSubrange(0 ..< rollValues.count - Int(numberOfValuesToBeDisplayed))
        }
        
        pitchValues.append(data.pitch)
        if pitchValues.count > Int(self.numberOfValuesToBeDisplayed) {
            pitchValues.removeSubrange(0 ..< pitchValues.count - Int(numberOfValuesToBeDisplayed))
        }
        
        yawValues.append(data.yaw)
        if yawValues.count > Int(self.numberOfValuesToBeDisplayed) {
            yawValues.removeSubrange(0 ..< yawValues.count - Int(numberOfValuesToBeDisplayed))
        }
    }
    
}
