//
//  BWCharacters.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import UIKit
import AVFoundation

// Our generic "Character"
public class Character: UIImageView {
    public var x: CGFloat
    public var y: CGFloat
    
    public override init(frame: CGRect){
        self.x = frame.origin.x
        self.y = frame.origin.y
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    public init(x: CGFloat, y: CGFloat, image: UIImage){
        self.x = x
        self.y = y
        super.init(image: image)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        super.init(coder: aDecoder)
    }
    
    // Moves the character
    func updatePosition(x: CGFloat, y: CGFloat){
        self.center = CGPoint(x: x, y: y)
    }
}

public enum BWReboColor{
    case red
    case hatless
    case blue
    case orange
    case purple
    case silver
}
// Lets us keep track of the order the Rebo's should appear
let reboArray : [BWReboColor] = [.hatless, .red, .blue, .orange, .purple, .silver]

/// Object class for Rebo.
public class Rebo: Character {
    
    var width : CGFloat
    var height: CGFloat
    var colour: BWReboColor
    
    public init(x: CGFloat, y: CGFloat, colour: BWReboColor){
        self.colour = colour
        width = BWCharacterStats.getReboSize(for: colour).width
        height = BWCharacterStats.getReboSize(for: colour).height
        super.init(frame: CGRect(x: x, y: y, width: self.width, height: self.height))
        self.image = BWCharacterStats.getReboImage(for: colour)
        self.tag = 2
    }
    
    func get(dx: CGFloat, viewWidth: CGFloat) -> CGFloat{
        
        let reboBoxWidth = self.frame.width / 2
        
        // Checking our character is not moving outside the bounds of the field
        if (self.center.x - reboBoxWidth + dx < 4 ||
            CGFloat(self.center.x + dx + reboBoxWidth) > viewWidth - 4){
            return 0
        }
        return dx
    }
    
    func get(dy: CGFloat, viewHeight: CGFloat) -> CGFloat{
        
        let reboBoxHeight = self.frame.height / 2
        
        // Checking our character is not moving outside the bounds of the field
        if (self.center.y - reboBoxHeight + dy < 4 ||
            CGFloat(self.center.y + dy + reboBoxHeight) > viewHeight - 4){
            return 0
        }
        return dy
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // A Default Rebo
        self.colour = .red
        self.width = 40.5
        self.height = 27
        super.init(coder: aDecoder)
    }
}

/// Object class for the bull character.
public class Bull: Character {
    
    public var amountOfBounces: Int
    public var dx: CGFloat
    public var dy: CGFloat
    public var width: CGFloat = BWCharacterStats.getBullSize().width
    public var height: CGFloat = BWCharacterStats.getBullSize().height
    
    public init(x: CGFloat, y: CGFloat){
        self.amountOfBounces = 0
        self.dx = BWCharacterStats.getBullSpeed()
        self.dy = BWCharacterStats.getBullSpeed()
        
        super.init(x: x, y: y, image: UIImage(named: "Bull")!)
        self.frame = CGRect(x: x, y: y, width: self.width, height: self.height)
        self.tag = 3
    }
    
    public init(pos: CGPoint){
        self.amountOfBounces = 0
        self.dx = BWCharacterStats.getBullSpeed()
        self.dy = BWCharacterStats.getBullSpeed()
    
        super.init(x: pos.x, y: pos.y, image: UIImage(named: "Bull")!)
        self.frame = CGRect(x: pos.x, y: pos.y, width: self.width, height: self.height)
        self.tag = 3
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.amountOfBounces = 0
        self.dx = BWCharacterStats.getBullSpeed()
        self.dy = BWCharacterStats.getBullSpeed()
        super.init(coder: aDecoder)
    }
}

// Global Characters
var rebo : Rebo!
var bulls : [Bull]!

