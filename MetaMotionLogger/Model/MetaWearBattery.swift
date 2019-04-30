//
//  MetaWearBattery.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.29.
//  Copyright © 2019 shoya140. All rights reserved.
//

public struct MetaWearBattery {
    let charge: Int
    let voltage: Int
    
    init(charge: Int, voltage: Int) {
        self.charge = charge
        self.voltage = voltage
    }
}
