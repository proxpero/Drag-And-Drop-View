//
//  MySourceView+SourceViewType.swift
//  Drag-and-Drop-View
//
//  Created by Todd Olsen on 1/9/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

extension MySourceView: SourceViewType {
    
    var draggingView: MySourceView {
        return MySourceView(color: color.colorWithSaturationFactor(0.6, brightnessFactor: 1.2))
    }
    
    override func mouseDragged(theEvent: NSEvent) {

        if let target = superview as? MyTargetView {
            target.reorderSubview(self, withEvent: theEvent)
        }
        
    }
    
}