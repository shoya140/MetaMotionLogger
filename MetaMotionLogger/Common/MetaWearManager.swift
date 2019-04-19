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
    func receivedAcc(data: MetaWearAcc)
    func receivedGyro(data: MetaWearGyro)
    func deviceConnected()
}

extension MetaWearManagerDelegate {
    func receivedAcc(data: MetaWearAcc) {
        
    }
    
    func receivedGyro(data: MetaWearGyro) {
        
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
    var accRange = 2
    var accFrequency = 100
    var gyroRange = 250
    var gyroFrequency = 100
    
    func connect(device: MetaWear) {
        self.device = device
        self.device?.connectAndSetup().continueOnSuccessWith {_ in
            let board = device.board
            
            mbl_mw_acc_set_odr(board, 100)
            mbl_mw_acc_write_acceleration_config(board)
            mbl_mw_datasignal_subscribe(mbl_mw_acc_get_packed_acceleration_data_signal(board), bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let _self: MetaWearManager = bridge(ptr: context!)
                _self.delegate?.receivedAcc(data: MetaWearAcc(x: Double(obj.x), y: Double(obj.y), z: Double(obj.z)))
            }
            mbl_mw_acc_enable_acceleration_sampling(board)
            mbl_mw_acc_start(board)
            
            mbl_mw_gyro_bmi160_set_odr(board, MBL_MW_GYRO_BMI160_ODR_100Hz)
            mbl_mw_gyro_bmi160_write_config(board)
            mbl_mw_datasignal_subscribe(mbl_mw_gyro_bmi160_get_packed_rotation_data_signal(board), bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let _self: MetaWearManager = bridge(ptr: context!)
                _self.delegate?.receivedGyro(data: MetaWearGyro(roll: Double(obj.x), pitch: Double(obj.y), yaw: Double(obj.z)))
            }
            mbl_mw_gyro_bmi160_enable_rotation_sampling(board)
            mbl_mw_gyro_bmi160_start(board)
            
            }
            .continueWith(.mainThread) {_ in
                self.delegate?.deviceConnected()
        }
    }
    
}
