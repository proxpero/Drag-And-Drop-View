//
//  TargetViewType.swift
//  Drag-and-Drop-View
//
//  Created by Todd Olsen on 1/8/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

protocol TargetViewType {
    
    typealias Source: SourceViewType
    
    func reorderSubview(subview: Source, withEvent event: NSEvent)
    func layoutSubviews(subviews: [NSView])
    
}

private enum DragDirection {
    case Up
    case Down
}

extension TargetViewType where Self: NSView, Source: NSView {
    
    func reorderSubview(subview: Source, withEvent event: NSEvent) {
        
        let position        = NSMaxY(frame) - NSMaxY(subview.frame)
        let initial         = convertPoint(event.locationInWindow, fromView: nil).y
        
        let draggingView    = subview.draggingView
        
        let draggingConstraints = [
            NSLayoutConstraint(item: draggingView, attribute: .Top,      relatedBy: .Equal, toItem: self, attribute: .Top,       multiplier: 1, constant: position),
            NSLayoutConstraint(item: draggingView, attribute: .Leading,  relatedBy: .Equal, toItem: self, attribute: .Leading,   multiplier: 1, constant: 0),
            NSLayoutConstraint(item: draggingView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing,  multiplier: 1, constant: 0)
        ]
        
        addSubview(draggingView)
        addConstraints(draggingConstraints)
        subview.hidden = true
        
        var previous = initial
        
        window?.trackEventsMatchingMask([.LeftMouseUpMask, .LeftMouseDraggedMask], timeout: NSDate.distantFuture().timeIntervalSinceNow, mode: NSEventTrackingRunLoopMode) { [unowned self] (dragEvent, stop) in
            
            guard dragEvent.type != NSEventType.LeftMouseUp else {
                
                draggingView.removeFromSuperview()
                self.removeConstraints(draggingConstraints)
                subview.hidden = false
                stop.memory = true
                return
                
            }
            
            let next = self.convertPoint(dragEvent.locationInWindow, fromView: nil).y
            
            draggingConstraints[0].constant = position + initial - next
        
            let middle      = NSMidY(draggingView.frame)
            let top         = NSMaxY(subview.frame)
            let bottom      = NSMinY(subview.frame)
            
            let movingUp    = next > previous && (middle > top)
            let movingDown  = next < previous && (middle < bottom)
            
            func moveSubview(direction: DragDirection) {
                
                let index = self.subviews.indexOf(subview)!
                let removeIndex: Int
                let insertIndex: Int
                
                switch direction {
                    case .Up:
                        removeIndex = index
                        insertIndex = index - 1
                    case .Down:
                        removeIndex = index + 1
                        insertIndex = index
                }
                
                let temp = self.subviews.removeAtIndex(removeIndex)
                self.subviews.insert(temp, atIndex: insertIndex)
                self.layoutSubviews(self.subviews.filter { $0 != draggingView })
                self.addConstraints(draggingConstraints)
                
            }
            
            if movingUp && subview != self.subviews.first! {
                moveSubview(.Up)
            }
            
            if movingDown && subview != self.subviews.last! {
                moveSubview(.Down)
            }
            
            previous = next
            
        }
    }
    
    func layoutSubviews(subviews: [NSView]) {
        
        removeConstraints(constraints)
        var prev: NSView?
        
        for subview in subviews {
            
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|", options: [], metrics: nil, views: ["subview": subview]))
            addConstraint(
                NSLayoutConstraint(
                    item:       subview,
                    attribute:  .Top,
                    relatedBy:  .Equal,
                    toItem:     prev != nil ? prev!     : self,
                    attribute:  prev != nil ? .Bottom   : .Top,
                    multiplier: 1,
                    constant:   prev != nil ? 1         : 0)
            )
            prev = subview
        }
        
        if prev != nil {
            addConstraint(NSLayoutConstraint(item: prev!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        }
    }
}