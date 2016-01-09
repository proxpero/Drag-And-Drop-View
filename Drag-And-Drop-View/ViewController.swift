//
//  ViewController.swift
//  Drag-And-Drop-View
//
//  Created by Todd Olsen on 1/9/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let target = view as? MyTargetView else { fatalError("Set the class of the view controller's view to `MyTargetView` in Main.Storyboard") }
        
        var subviews: [MySourceView] = []
        
        let hue = CGFloat(arc4random()) / 0xFFFFFFFF
        
        for _ in (1...12) {
            subviews.append(MySourceView(color: NSColor.randomColor(hue)))
        }
        
        target.subviews = subviews.map { $0 as NSView }
        target.layoutSubviews(target.subviews)

    }

}

