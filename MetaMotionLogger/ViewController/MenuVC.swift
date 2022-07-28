//
//  MenuVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2022/07/28.
//  Copyright © 2022 shoya140. All rights reserved.
//

import UIKit
import MetaWear

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MetaWearManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var connecedDevices: [MetaWear] = []
    var activeIndexPath = IndexPath(row: -1, section: -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navBar.scrollEdgeAppearance = appearance
        
        tableView.dataSource = self
        tableView.delegate = self
        
        MetaWearManager.sharedObject.delegates.append(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        connecedDevices = MetaWearManager.sharedObject.devices
    }
    
    @IBAction func pairingButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PairingVC") as! PairingVC
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connecedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = connecedDevices[indexPath.row]
        cell.textLabel?.text = device.mac
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activeIndexPath == indexPath {
            return
        }
        let vc = storyboard?.instantiateViewController(identifier: "MonitoringVC") as! MonitoringVC
        vc.device = self.connecedDevices[indexPath.row]
        let nvc = UINavigationController(rootViewController: vc)
        showDetailViewController(nvc, sender: nvc)
        activeIndexPath = indexPath
    }
    
    // MARK: - MetaWearManager delegate
    
    func deviceConnected() {
        connecedDevices = MetaWearManager.sharedObject.devices
        tableView.reloadData()
    }
    
}
