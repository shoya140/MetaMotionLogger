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

class PairingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ScannerModelDelegate, MetaWearManagerDelegate {

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
        
        MetaWearManager.sharedObject.delegate = self
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
    
    // MARK: - Scanner model delegate
    
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
            MetaWearManager.sharedObject.connect(device: item.device)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func scannerModel(_ scannerModel: ScannerModel, errorDidOccur error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Meta wear manager delegate
    
    func deviceConnected() {
        self.dismissHUD(completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
