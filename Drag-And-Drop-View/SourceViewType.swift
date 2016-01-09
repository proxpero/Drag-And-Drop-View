//
//  SourceViewType.swift
//  Drag-and-Drop-View
//
//  Created by Todd Olsen on 1/8/16.
//  Copyright © 2016 Todd Olsen. All rights reserved.
//

import Cocoa

protocol SourceViewType {
    
    var draggingView: Self { get }
    
}
