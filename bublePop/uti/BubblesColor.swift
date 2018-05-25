//
//  RandomNumbers.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 24/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
// https://gist.github.com/zmeyc/762b33b8428e8a0fface

import Foundation
import UIKit
import SceneKit
import GameKit
public extension Float {
    public static func random(min: Float, max: Float) -> Float {
        let random = Float(arc4random(UInt32.self)) / Float(UInt32.max)
        return (random * (max - min)) + min
    }
}
public func arc4random <T: ExpressibleByIntegerLiteral> (_ type: T.Type) -> T {
    var random: T = 0
    arc4random_buf(&random, Int(MemoryLayout<T>.size))
    return random
}

let returnBubbleColour:[UIColor] = [
    UIColor.green,
    UIColor.boom
]
func randomPercent() -> Int {
    return Int(arc4random_uniform(100))
}
extension UIColor { //Handle Bubbles Probability
    public static func random() -> UIColor {
        let randomNumber = randomPercent()
        switch(randomNumber) {
        case 0..<60: return returnBubbleColour[0] //return red bubble
        default: return returnBubbleColour[1] //return black bubble
  
        }
    }
    //http://uicolor.xyz/#/rgb-to-ui this is website to get UIColor in RPG
    public static var boom: UIColor {
        return UIColor(red: 0.13, green: 0.81, blue: 0.37, alpha: 1)
    }
    public static var green: UIColor {
        return UIColor(red: 0.0, green:1.0, blue:0.35, alpha:1.0)
    }
}
