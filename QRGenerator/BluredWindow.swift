//
//  BluredWindow.swift
//  QRGenerator
//
//  Created by Eugene Bokhan on 10/7/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Foundation
import Cocoa

class BluredWindow: NSWindow {
    
    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true
        self.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        self.isMovableByWindowBackground = true
        self.titlebarAppearsTransparent = true
        self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
    }
}
