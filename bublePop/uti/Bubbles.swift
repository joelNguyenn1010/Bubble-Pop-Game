//
//  Shapes.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 24/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import Foundation

enum Bubbles: Int {
    
    case sphere //get the sphere geometry
    static func random() -> Bubbles {
        let maxValue = sphere.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return Bubbles(rawValue: Int(rand))!
    }
}
