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
    func receivedMag(data: MetaWearMag)
    func receivedQuat(data: MetaWearQuat)
    func receivedBattery(data: MetaWearBattery)
    func deviceConnected()
}

extension MetaWearManagerDelegate {
    func receivedAcc(data: MetaWearAcc) {
        
    }
    
    func receivedGyro(data: MetaWearGyro) {
        
    }

    func receivedMag(data: MetaWearMag) {
        
    }
    
    func receivedQuat(data: MetaWearQuat) {
        
    }

    func receivedBattery(data: MetaWearBattery) {
        
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
    
    var delegates = RMWeakSet<MetaWearManagerDelegate>()
    var devices: [MetaWear] = []
    var batteryLevel: Int = 100
    
    private override init() {
        super.init()
        self.getBatteryStateWithInterval()
    }
    
    func connect(device: MetaWear) {
        device.connectAndSetup().continueOnSuccessWith {_ in
            let board = device.board
            
            mbl_mw_acc_set_odr(board, 100)
            mbl_mw_acc_write_acceleration_config(board)
            mbl_mw_datasignal_subscribe(mbl_mw_acc_get_packed_acceleration_data_signal(board), bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let d = MetaWearAcc(x: Double(obj.x), y: Double(obj.y), z: Double(obj.z))
                if FileWriter.sharedWriter.isRecording {
                    FileWriter.sharedWriter.write(data: NSString(format: "acc,%f,%f,%f,\n", d.x, d.y, d.z) as String)
                }
                (bridge(ptr: context!) as MetaWearManager).delegates.forEach{ $0.receivedAcc(data: d) }
            }
            mbl_mw_acc_enable_acceleration_sampling(board)
            mbl_mw_acc_start(board)
            
            mbl_mw_gyro_bmi270_set_odr(board, MBL_MW_GYRO_BOSCH_ODR_100Hz)
            mbl_mw_gyro_bmi270_write_config(board)
            mbl_mw_datasignal_subscribe(mbl_mw_gyro_bmi270_get_packed_rotation_data_signal(board), bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let d = MetaWearGyro(roll: Double(obj.x), pitch: Double(obj.y), yaw: Double(obj.z))
                if FileWriter.sharedWriter.isRecording {
                    FileWriter.sharedWriter.write(data: NSString(format: "gyro,%f,%f,%f,\n", d.roll, d.pitch, d.yaw) as String)
                }
                (bridge(ptr: context!) as MetaWearManager).delegates.forEach{ $0.receivedGyro(data: d) }
            }
            mbl_mw_gyro_bmi270_enable_rotation_sampling(board)
            mbl_mw_gyro_bmi270_start(board)
            
            mbl_mw_mag_bmm150_set_preset(board, MBL_MW_MAG_BMM150_PRESET_REGULAR)
            mbl_mw_datasignal_subscribe(mbl_mw_mag_bmm150_get_packed_b_field_data_signal(board) , bridge(obj: self)) { (context, data) in
                let obj: MblMwCartesianFloat = data!.pointee.valueAs()
                let d = MetaWearMag(x: Double(obj.x), y: Double(obj.y), z: Double(obj.z))
                if FileWriter.sharedWriter.isRecording {
                    FileWriter.sharedWriter.write(data: NSString(format: "mag,%f,%f,%f,\n", d.x, d.y, d.z) as String)
                }
                (bridge(ptr: context!) as MetaWearManager).delegates.forEach{ $0.receivedMag(data: d) }
            }
            mbl_mw_mag_bmm150_enable_b_field_sampling(board)
            mbl_mw_mag_bmm150_start(board)
            
            mbl_mw_sensor_fusion_set_mode(board, MBL_MW_SENSOR_FUSION_MODE_IMU_PLUS)
            mbl_mw_sensor_fusion_write_config(board)
            mbl_mw_datasignal_subscribe(mbl_mw_sensor_fusion_get_data_signal(board, MBL_MW_SENSOR_FUSION_DATA_QUATERNION), bridge(obj: self)) { (context, data) in
                let obj: MblMwQuaternion = data!.pointee.valueAs()
                let d = MetaWearQuat(w: Double(obj.w), x: Double(obj.x), y: Double(obj.y), z: Double(obj.z))
                if FileWriter.sharedWriter.isRecording {
                    FileWriter.sharedWriter.write(data: NSString(format: "quat,%f,%f,%f,%f\n", d.w, d.x, d.y, d.z) as String)
                }
                (bridge(ptr: context!) as MetaWearManager).delegates.forEach{ $0.receivedQuat(data: d) }
            }
            mbl_mw_sensor_fusion_enable_data(board, MBL_MW_SENSOR_FUSION_DATA_QUATERNION)
            mbl_mw_sensor_fusion_start(board)
            
            self.devices.append(device)
        }.continueWith(.mainThread) {_ in
            self.delegates.forEach{ $0.deviceConnected() }
        }
    }
    
    func getBatteryStateWithInterval() {
        for device in self.devices {
            let board = device.board
            mbl_mw_settings_get_battery_state_data_signal(board)?.read().continueOnSuccessWith {obj in
                let battery: MblMwBatteryState = obj.valueAs()
                let d = MetaWearBattery(charge: Int(battery.charge), voltage: Int(battery.voltage))
                if FileWriter.sharedWriter.isRecording {
                    FileWriter.sharedWriter.write(data: NSString(format: "battery,%d,%d,,\n", d.charge, d.voltage) as String)
                }
                self.batteryLevel = d.charge
                self.delegates.forEach{ $0.receivedBattery(data: d) }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.getBatteryStateWithInterval()
        }
    }
    
}
