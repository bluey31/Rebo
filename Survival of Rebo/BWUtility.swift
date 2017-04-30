//
//  BWUtility.swift
//  Survival of Rebo
//
//  Some utility functions
//
//  Created by Brendon Warwick on 30/04/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import Foundation
import UIKit

class BWUtility {
    /// Returns if the device is an iPad
    class func isDeviceiPad() -> Bool {
        let bounds = UIScreen.main.bounds
        let (w, h) = (bounds.width, bounds.height)
        
        switch (w, h){
            
            /* iPad */
        // 9.7 inch screens (Mini, iPad Air, etc)
        case (768, 1024) :  return true
        // 12.9 inch screen (Pro)
        case (1024, 1366):  return true
            
            /* iPhone */
        // 4 inch screens (5, SE, etc)
        case (320, 568)  :  return false
        // 4.7 inch screen (6, 7, etc)
        case (375, 667)  :  return false
        // 5.5 inch screen (6+)
        case (414, 736)  :  return false
            
        default          :  return true  // Sim
        }
    }
    
    /// Used by the dialog to know if the screen will be too squished for extar details.
    class func isScreenTooSmallForExtraDetails() -> Bool {
        let bounds = UIScreen.main.bounds
        let (w, h) = (bounds.width, bounds.height)
        
        switch (w, h){
            
            /* iPad */
        // 9.7 inch screens (Mini, iPad Air, etc)
        case (768, 1024) :  return false
        // 12.9 inch screen (Pro)
        case (1024, 1366):  return false
            
            /* iPhone */
        // 4 inch screens (5, SE, etc)
        case (320, 568)  :  return true
        // 4.7 inch screen (6, 7, etc)
        case (375, 667)  :  return false
        // 5.5 inch screen (6+)
        case (414, 736)  :  return false
            
        default          :  return true  // Sim
        }
    }
}
