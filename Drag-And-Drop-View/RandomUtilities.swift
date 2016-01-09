//
//  RandomUtilities.swift
//  Drag-And-Drop-View
//
//  Created by Todd Olsen on 1/9/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

class FlippedClipView: NSClipView {
    override var flipped: Bool { return true }
}

extension NSColor {
    
    convenience init(rgb: String) {
        
        guard rgb.characters.count == 6 else { fatalError("Invalid rgb value: \(rgb)") }
        
        let scanner = NSScanner(string: rgb)
        var hexValue: UInt32 = 0
        
        guard scanner.scanHexInt(&hexValue) else { fatalError("Scan hex \(rgb) error") }
        
        self.init(
            red:    CGFloat((hexValue & 0xFF0000) >> 0x10)    / 255.0,
            green:  CGFloat((hexValue & 0x00FF00) >> 0x01)    / 255.0,
            blue:   CGFloat((hexValue & 0x0000FF) >> 0x00)    / 255.0,
            alpha:  1.0
        )
    }
    
    func colorWithSaturationFactor(s: CGFloat, brightnessFactor b: CGFloat) -> NSColor {
        
        return NSColor(
            hue:        hueComponent,
            saturation: saturationComponent * s,
            brightness: brightnessComponent * b,
            alpha:      1.0
        )
        
    }
    
    static func randomColor(hue: CGFloat = CGFloat(arc4random()) / 0xFFFFFFFF) -> NSColor {
        
        return NSColor(
            hue:            hue,
            saturation:     CGFloat(arc4random()) / 0xFFFFFFFF,
            brightness:     CGFloat(arc4random()) / 0xFFFFFFFF,
            alpha:          1.0
        )
        
    }
}