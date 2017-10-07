//
//  BlurredView.swift
//  QRGenerator
//
//  Created by Eugene Bokhan on 10/7/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Foundation
import Cocoa

class BlurredView: NSVisualEffectView {
    
    override func viewDidMoveToWindow() {
        self.material = NSVisualEffectView.Material.dark
        self.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        self.state = NSVisualEffectView.State.active
    }
    
}
