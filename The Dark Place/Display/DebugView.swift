//
//  DebugView.swift
//  The Dark Place
//
//  Created by Twohy on 9/3/18.
//  Copyright © 2018 TwohyTutorials. All rights reserved.
//

import Cocoa

class DebugView: NSView {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        self.backgroundColor = NSColor.init(calibratedRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    
}
