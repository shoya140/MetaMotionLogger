//
//  MonitoringVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit
import MetaWear

class MonitoringVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MetaWearManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var device: MetaWear!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        if device != nil {
            self.title = device.mac
        }
        
        MetaWearManager.sharedObject.delegates.append(self)
        
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        MetaWearManager.sharedObject.delegates.remove(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "BMI270 Accelerometer"
        case 1:
            return "BMI270 Gyroscope"
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
                (cell.viewWithTag(1) as! UILabel).text = "X:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", accXValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = accXValues
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Y:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", accYValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = accYValues
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Z:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", accZValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 2
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -2
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = accZValues
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Roll:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.0f", rollValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1000
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1000
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = rollValues
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Pitch:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.0f", pitchValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1000
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1000
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = pitchValues
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Yaw:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.0f", yawValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1000
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1000
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = yawValues
                return cell
            }
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "W:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", quatWValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = quatWValues
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "X:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", quatXValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = quatXValues
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Y:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", quatYValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = quatYValues
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
                (cell.viewWithTag(1) as! UILabel).text = "Z:"
                (cell.viewWithTag(2) as! UILabel).text = String(format: "%.2f", quatZValues.last!)
                (cell.viewWithTag(3) as! SIGraphView).maximumValue = 1
                (cell.viewWithTag(3) as! SIGraphView).minimumValue = -1
                (cell.viewWithTag(3) as! SIGraphView).minimumNumberOfValuesToBeDisplayed = numberOfValuesToBeDisplayed100Hz
                (cell.viewWithTag(3) as! SIGraphView).values = quatZValues
                return cell
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.033) {
            if UIApplication.shared.applicationState == .active  {
                self.tableView.reloadData()
            }
            self.reloadData()
        }
    }
    
    func receivedAcc(data: MetaWearAcc, device: MetaWear) {
        if (self.device != device) {
            return
        }
        accXValues.append(data.x)
        if accXValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accXValues.removeFirst()
        }
        
        accYValues.append(data.y)
        if accYValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accYValues.removeFirst()
        }
        
        accZValues.append(data.z)
        if accZValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            accZValues.removeFirst()
        }
    }
    
    func receivedGyro(data: MetaWearGyro, device: MetaWear) {
        if (self.device != device) {
            return
        }
        rollValues.append(data.roll)
        if rollValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            rollValues.removeFirst()
        }
        
        pitchValues.append(data.pitch)
        if pitchValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            pitchValues.removeFirst()
        }
        
        yawValues.append(data.yaw)
        if yawValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            yawValues.removeFirst()
        }
    }
    
    func receivedQuat(data: MetaWearQuat, device: MetaWear) {
        if (self.device != device) {
            return
        }
        if data.w.isNaN {
            return
        }
        
        quatWValues.append(data.w)
        if quatWValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatWValues.removeFirst()
        }
        
        quatXValues.append(data.x)
        if quatXValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatXValues.removeFirst()
        }
        
        quatYValues.append(data.y)
        if quatYValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatYValues.removeFirst()
        }
        
        quatZValues.append(data.z)
        if quatZValues.count > Int(self.numberOfValuesToBeDisplayed100Hz) {
            quatZValues.removeFirst()
        }
    }
}
