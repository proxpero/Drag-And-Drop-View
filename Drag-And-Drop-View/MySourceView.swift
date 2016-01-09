//
//  MySourceView.swift
//  Drag-and-Drop-View
//
//  Created by Todd Olsen on 1/6/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

final class MySourceView: NSView {

    internal let color: NSColor
    
    init(color: NSColor = NSColor.randomColor()) {
        self.color = color
        super.init(frame: NSZeroRect)
        self.translatesAutoresizingMaskIntoConstraints = false
        setHeight(40)
    }
    
    required init?(coder: NSCoder) {
        self.color = NSColor.randomColor()
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setHeight(40)
    }
    
    private func setHeight(height: CGFloat) {
        self.addConstraint(
            NSLayoutConstraint(
                item:       self,
                attribute:  .Height,
                relatedBy:  .Equal,
                toItem:     nil,
                attribute:  .NotAnAttribute,
                multiplier: 1,
                constant:   height
            )
        )
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        color.setFill()
        NSRectFill(dirtyRect)
        
        super.drawRect(dirtyRect)
    }

}

