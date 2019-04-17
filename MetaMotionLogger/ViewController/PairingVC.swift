//
//  PairingVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.17.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit
import MetaWear
import MetaWearCpp
import BoltsSwift
import iOSDFULibrary

class PairingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var scannerModel: ScannerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scannerModel = ScannerModel(delegate: self as ScannerModelDelegate)
        scannerModel.isScanning = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scannerModel.isScanning = false
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannerModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = scannerModel.items[indexPath.row].device
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.mac
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showHUD(text: "Initializing")
        self.scannerModel.items[indexPath.row].toggleConnect()
    }
    
}

extension PairingVC: ScannerModelDelegate {
    func scannerModel(_ scannerModel: ScannerModel, didAddItemAt idx: Int) {
        tableView.reloadData()
    }
    
    func scannerModel(_ scannerModel: ScannerModel, confirmBlinkingItem item: ScannerModelItem, callback: @escaping (Bool) -> Void) {
        self.dismissHUD()
        
        let alert = UIAlertController(title: "Confirm Device", message: "Do you see a blinking green LED?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
            callback(false)
        })
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            callback(true)
            
            self.showHUD(text: "Connecting")
            item.device.initialDeviceSetup().continueWith(.mainThread) {_ in
                self.dismissHUD()
                self.dismiss(animated: true, completion: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func scannerModel(_ scannerModel: ScannerModel, errorDidOccur error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MetaWear {
    // Call once to setup a device
    func initialDeviceSetup(temperaturePeriodMsec: UInt32 = 1000) -> Task<()> {
        return eraseDevice().continueWithTask { _ -> Task<Task<MetaWear>> in
            return self.connectAndSetup()
            }.continueOnSuccessWithTask { _ -> Task<()> in
                let state = DeviceState(temperaturePeriodMsec: temperaturePeriodMsec)
                return state.setup(self)
            }.continueWithTask { t -> Task<()> in
                if !t.faulted {
                    self.remember()
                } else {
                    self.eraseDevice()
                }
                return t
        }
    }
    
    // If you no longer need a device call this
    @discardableResult
    func eraseDevice() -> Task<MetaWear> {
        // Remove the on-disk state
        try? FileManager.default.removeItem(at: uniqueUrl)
        // Drop the device from the MetaWearScanner saved list
        forget()
        // Reset and clear all data from the device
        return connectAndSetup().continueOnSuccessWithTask {
            self.clearAndReset()
            return $0
        }
    }
}
