//
//  ViewController.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import UIKit

// The state of the game
enum BWGameState{
    case won
    case lost
}

// The model view controller:
public class BWReboGameController: UIViewController {
    
    // MARK: Attributes
    var drawLayer: CAShapeLayer!
    @IBOutlet weak var gameplayField: UIView!
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Class & View Initialization methods
    
    public override func viewDidLoad() {
        hatlessReboChecks()
        play()
    }
    
    func hatlessReboChecks(){
        let hasUnlockedHatlessRebo = UserDefaults.standard.bool(forKey: BWHatlessReboUnlocked)
        
        if !hasUnlockedHatlessRebo {
            // Easter Egg
            let hatlessReboUnlockGesture = UITapGestureRecognizer(target: self, action: #selector(self.hatlessReboTapDetected))
            hatlessReboUnlockGesture.numberOfTapsRequired = 10
            headerBar.addGestureRecognizer(hatlessReboUnlockGesture)
        }
    }
    
    // Styles our main parent view
    public override func viewDidLayoutSubviews() {
        scoreLabel.font = titleLabel.font
        drawFieldBounds(color: UIColor.red)
    }
    
    func play() {
        gameField = BWGameField.instanceOfNib(scoreLabel: scoreLabel)
        gameplayField.backgroundColor = .black
        // Load the gameplay handler
        gameplayField.addSubview(gameField)
    }
    
    func drawFieldBounds(color: UIColor){
        
        if (drawLayer != nil){
            drawLayer.path = nil
        }
        
        if gameplayField != nil {
            drawLayer = CAShapeLayer()
            drawLayer.strokeColor = color.cgColor
            drawLayer.fillColor = color.cgColor
            drawLayer.lineWidth = 4.0
        
            gameplayField.layer.addSublayer(drawLayer)
            
            let rectPath = UIBezierPath()
            let viewWidth = gameplayField.frame.size.width;
            let viewHeight = gameplayField.frame.size.height;
            
            rectPath.move(to: CGPoint(x: 4, y: 4))
            rectPath.addLine(to: CGPoint(x: 4, y: viewHeight-2))
            
            rectPath.move(to: CGPoint(x: 4, y: viewHeight-4))
            rectPath.addLine(to: CGPoint(x: viewWidth-2, y: viewHeight-4))
            
            rectPath.move(to: CGPoint(x: viewWidth-4, y: viewHeight-4))
            rectPath.addLine(to: CGPoint(x: viewWidth-4, y: 2))
            
            rectPath.move(to: CGPoint(x: viewWidth-4, y: 4))
            rectPath.addLine(to: CGPoint(x: 2, y: 4))
            
            drawLayer.path = rectPath.cgPath
        }
    }
    
    // MARK: Hatless Rebo Unlock
    
    var counter = 4
    
    func hatlessReboTapDetected(){
        // User has unlocked hatless Rebo
        UserDefaults.standard.set(true, forKey: BWHatlessReboUnlocked)
        titleLabel.text = "Unlocked Secret Rebo!"
        
        // Set a timer to dismiss unlock message
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUnlockCountdown), userInfo: nil, repeats: true)
    }
    
    func updateUnlockCountdown(){
        if counter > 0 {
            counter -= 1
        }else{
            titleLabel.text = "Survival of Rebo"
        }
    }
}


