//
//  MetaWearManager.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

import Foundation
import MetaWear
import MetaWearCpp

protocol MetaWearManagerDelegate: class {
    func sensorDataReceived(data: [String:Float])
    func deviceConnected()
}

extension MetaWearManagerDelegate {
    func sensorDataReceived(data: [String:Float]) {
        
    }
    
    func deviceConnected() {
        
    }
}

class MetaWearManager: NSObject {
    
    class var sharedObject: MetaWearManager {
        struct Static {
            static let object: MetaWearManager = MetaWearManager()
        }
        return Static.object
    }
    
    weak var delegate: MetaWearManagerDelegate? = nil
    var device: MetaWear? = nil
    
    func connect(device: MetaWear) {
        self.device = device
        self.device?.connectAndSetup().continueOnSuccessWith {_ in
            // configure ....
            let board = device.board
            let signal = mbl_mw_acc_get_acceleration_data_signal(board)
            mbl_mw_acc_get_acceleration_data_signal(board)
            mbl_mw_datasignal_subscribe(signal, bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let _self: MetaWearManager = bridge(ptr: context!)
                _self.delegate?.sensorDataReceived(data: ["x": obj.x, "y": obj.y, "z": obj.x])
            }
            mbl_mw_acc_enable_acceleration_sampling(board)
            mbl_mw_acc_start(board)
            }
            .continueWith(.mainThread) {_ in
                self.delegate?.deviceConnected()
        }
    }
    
}
