//
//  BWDevice.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import Foundation
import UIKit

class BWCharacterClass {
    
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
    
    /// Returns the size of Rebo respective to the devices screen size.
    class func getReboSize(for color: BWReboColor) -> CGSize{
        let bounds = UIScreen.main.bounds
        let (w, h) = (bounds.width, bounds.height)
        
        var multiplier : CGFloat = 1
        
        switch (w, h){
            
            /* iPad */
            // 9.7 inch screens (Mini, iPad Air, etc)
            case (768, 1024) :  multiplier = 1
            // 12.9 inch screen (Pro)
            case (1024, 1366):  multiplier = 1.333334
            
            /* iPhone */
            // 4 inch screens (5, SE, etc)
            case (320, 568)  :  multiplier = 0.42666667
            // 4.7 inch screen (6, 7, etc)
            case (375, 667)  :  multiplier = 0.5
            // 5.5 inch screen (6+)
            case (414, 736)  :  multiplier = 0.552
            
            default          :  multiplier = 0.5  // Sim
        }
        
        if (color == .hatless){
            return CGSize(width: 60 * multiplier, height: 60 * multiplier)
        }
        return CGSize(width: 81 * multiplier, height: 54 * multiplier)
    }
    
    /// Returns the size of each Bull respective to the devices screen size.
    class func getBullSize() -> CGSize{
        let bounds = UIScreen.main.bounds
        let (w, h) = (bounds.width, bounds.height)
        
        var multiplier : CGFloat = 1
        
        switch (w, h){
            
        /* iPad */
        // 9.7 inch screens (Mini, iPad Air, etc)
        case (768, 1024) :  multiplier = 1
        // 12.9 inch screen (Pro)
        case (1024, 1366):  multiplier = 1.333334
        
        /* iPhone */
        // 4 inch screens (5, SE, etc)
        case (320, 568)  :  multiplier = 0.42666667
        // 4.7 inch screen (6, 7, etc)
        case (375, 667)  :  multiplier = 0.5
        // 5.5 inch screen (6+)
        case (414, 736)  :  multiplier = 0.552
            
        default          :  multiplier = 0.5  // Sim
        }
        
        return CGSize(width: 67.5 * multiplier, height: 63.45 * multiplier)
    }

    /// Returns the speed of the Bulls respective to the devices screen size.
    class func getBullSpeed() -> CGFloat{
        let bounds = UIScreen.main.bounds
        let (w, h) = (bounds.width, bounds.height)
        
        switch (w, h){
            
        /* iPad */
        // 9.7 inch screens (Mini, iPad Air, etc)
        case (768, 1024) :  return 6
        // 12.9 inch screen (Pro)
        case (1024, 1366):  return 6.2
            
        /* iPhone */
        // 4 inch screens (5, SE, etc)
        case (320, 568)  :  return 3.4133332
        // 4.7 inch screen (6, 7, etc)
        case (375, 667)  :  return 4
        // 5.5 inch screen (6+)
        case (414, 736)  :  return 4.416
            
        default          :  return 4.8  // Sim
        }
        
    }
    
    /// Returns the image associated with a Rebo.
    class func getReboImage(for colour: BWReboColor) -> UIImage{
        var reboColour : String
        
        switch colour {
        case .red:
            reboColour = "Rebo"
        case .hatless:
            reboColour = "Hatless Rebo"
        case .blue:
            reboColour = "Blue Rebo"
        case .orange:
            reboColour = "Orange Rebo"
        case .purple:
            reboColour = "Purple Rebo"
        case .silver:
            reboColour = "Silver Rebo"
        }
        
        return UIImage(named: reboColour)!
    }
    
    /// Returns the minimum score required to unlock the standard Rebo's.
    class func getMinimumScore(for currentRebo: BWReboColor) -> Int{
        var reboMinimumScore : Int
        
        switch currentRebo {
        case .red:
            reboMinimumScore = 0
        case .blue:
            reboMinimumScore = 35
        case .orange:
            reboMinimumScore = 55
        case .purple:
            reboMinimumScore = 85
        case .silver:
            reboMinimumScore = 130
        default:
            reboMinimumScore = 0
        }
        
        return reboMinimumScore
    }
}
