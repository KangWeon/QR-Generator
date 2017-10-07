//
//  OnlyIntegerValueFormatter.swift
//  QRGenerator
//
//  Created by Eugene Bokhan on 10/7/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Foundation

class OnlyIntegerValueFormatter: NumberFormatter {
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }
        
        // Optional: limit input length
        if partialString.characters.count > 3 {
            return false
        }
        
        // Actual check
        return Int(partialString) != nil
    }
}
