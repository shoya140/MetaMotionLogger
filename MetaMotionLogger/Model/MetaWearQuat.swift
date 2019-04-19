//
//  MetaWearQuat.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.19.
//  Copyright © 2019 shoya140. All rights reserved.
//

public struct MetaWearQuat {
    let w: Double
    let x: Double
    let y: Double
    let z: Double
    
    init(w: Double, x: Double, y: Double, z: Double) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}
