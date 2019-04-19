//
//  MetaWearGyro.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

public struct MetaWearGyro {
    let roll: Double
    let pitch: Double
    let yaw: Double
    
    init(roll: Double, pitch: Double, yaw: Double) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
}
