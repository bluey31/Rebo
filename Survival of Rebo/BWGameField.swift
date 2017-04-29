//
//  BWGameplayHandler.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

import UIKit
import AVFoundation

/**
 *
 * BWGameplayHandler handles controlling the logic behind the game, acting as a backend engine for the front end BWReboGameController.
 *
 */

class BWGameField: UIView{
    
    // MARK: Attributes and Delegates
    
    static var currentRebo: BWReboColor!
    static var gameStarted: Bool!
    static var scoreLabel: UILabel!
    static var tap: UITapGestureRecognizer!
    static var doubleTap: UITapGestureRecognizer!
    
    // Pause Attributes
    static var paused: Bool!
    @IBOutlet weak var pausedLabel: UILabel!
    
    // Dialog Box attributes
    @IBOutlet weak var dialogBox: UIView!
    @IBOutlet weak var dialogTitle: UILabel!
    @IBOutlet weak var dialogMessage: UILabel!
    @IBOutlet weak var dialogHighScoreLabel: UILabel!
    @IBOutlet weak var dialogConfirmationMessage: UILabel!
    
    // Character selection attributes
    @IBOutlet weak var unlockedAtLabel: UILabel!
    @IBOutlet weak var lockedReboImage: UIImageView!
    static var currentPositionInReboArray : Int!
    static var lastUnlockedPositionInReboArray : Int!
    
    // Constraints
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var highScoreBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var reboSelectionHeight: NSLayoutConstraint!
    
    //MARK: Initialization
    
    /// Returns the view when called
    class func instanceOfNib(scoreLabel: UILabel!) -> BWGameField {
        self.scoreLabel = scoreLabel
        self.gameTimer = nil
        self.currentPositionInReboArray = 1
        self.lastUnlockedPositionInReboArray = self.currentPositionInReboArray
        self.currentRebo = reboArray[currentPositionInReboArray]
        self.gameStarted = false
        self.paused = false
        return UINib(nibName: "BWGameField", bundle: nil).instantiate(withOwner: nil, options: nil).first as! BWGameField
    }
    
    override func awakeFromNib() {
        // Let the user drag Rebo by dragging the view
        let drag = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(panRecognizer:)))
        self.addGestureRecognizer(drag)
        
        setupDialogBox()
        updateScoreLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Wait until subviews have been laid out before starting the game so that the start game dialog gets presented correctly
        if !BWGameField.gameStarted {
            startGame();
        }
    }
    
    // MARK: Score Label Methods
    
    func updateScoreLabel(){
        BWGameField.scoreLabel!.text = "Score: \(currentScore())"
    }
    
    // MARK: Start Game Methods
    
    func startGame(){
        // Set the tap recognizer
        BWGameField.tap = UITapGestureRecognizer(target: self, action: #selector(rotate))
        BWGameField.doubleTap = UITapGestureRecognizer(target: self, action: #selector(pause))
        BWGameField.doubleTap.numberOfTapsRequired = 2
        
        showStartDialog()
    }
    
    // MARK: Dialog Box Stuff
    
    /// Set up the dialog box
    func setupDialogBox(){
        
        if (BWCharacterStats.isDeviceiPad()){
            titleTopConstraint.constant += 32
            highScoreBottomConstraint.constant += 32
            reboSelectionHeight.constant += 40
            confirmationTopConstraint.constant += 16
            confirmationBottomConstraint.constant += 16
            layoutIfNeeded()
            pausedLabel.font = UIFont(name: "Chalkduster", size: 28)
            dialogTitle.font = UIFont(name: "Chalkduster", size: 30)
            dialogMessage.font = UIFont(name: "Chalkduster", size: 24)
            dialogHighScoreLabel.font = UIFont(name: "Chalkduster", size: 26)
            dialogConfirmationMessage.font = UIFont(name: "Chalkduster", size: 26)
        }
        
        dialogBox.backgroundColor = .white
        dialogBox.layer.cornerRadius = 12
        dialogBox.tag = 1
    }
    
    /// Present a dialog that when clicked prompts a start to the game
    func showStartDialog(){
        // Show the dialog
        
        var message = "Drag the screen to move Rebo and help him survive."
        if (!BWCharacterStats.isScreenTooSmallForExtraDetails()){
            message += "\n\n\nDouble tap to pause."
        }
        showDialog(title: "Welcome to Rebo ♥️",
                   message: message,
                   continueMessage: "Tap to Play",
                   showHighScore: false)
        
        BWGameField.gameStarted = true
        self.addGestureRecognizer(BWGameField.tap)
    }
    
    /// Shows the main dialog with given data
    func showDialog(title: String, message: String, continueMessage: String, showHighScore: Bool){
        dialogBox.isHidden = false
        dialogTitle.text = title
        dialogMessage.text = message
        if (showHighScore){
            setHighscoreOnDialog()
        }else{
            dialogHighScoreLabel.text = "Select your Rebo:"
        }
        dialogConfirmationMessage.text = continueMessage
        setCurrentSelectedRebo(basedOff: .lastUnlockedCharacter)
        self.bringSubview(toFront: dialogBox)
    }
    
    /// Just hides the dialog
    func hideDialog(){
        dialogBox.isHidden = true
    }
    
    func setHighscoreOnDialog(){
        let highScore = UserDefaults.standard.integer(forKey: BWHighScore)
        dialogHighScoreLabel.text = "High Score: \(highScore)"
    }
    
    // MARK: Gameplay
    
    static var gameTimer: Timer? = nil
    
    /// The method called to kick off a game
    @objc func rotate(){
        
        // Remove all the old bulls (if they are present) (2) and the original rebo (3)
        for view in self.subviews {
            if view.tag == 2 || view.tag == 3 {
                view.removeFromSuperview()
            }
        }
        
        // Initialize Rebo
        rebo = Rebo(x: self.center.x, y: self.center.y, colour: BWGameField.currentRebo)
        
        self.removeGestureRecognizer(BWGameField.tap)
        self.addGestureRecognizer(BWGameField.doubleTap)
        
        // Hide the dialog
        hideDialog()
        
        // (Re)-Load the bulls array and load them into the view
        bulls = [Bull]()
        bulls = [Bull(pos: self.getRandomPoisitonForBull()), Bull(pos: self.getRandomPoisitonForBull())]
        loadCharactersInto(view: self)
        
        // Kick off the game timer (effectively frame processes every tick)
        BWGameField.gameTimer = nil
        BWGameField.gameTimer = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(moveBulls), userInfo: nil, repeats: true)
        
        BWGameField.paused = false
        pausedLabel.isHidden = true
        
        // Set score back to 0 (important if we are restarting a game)
        updateScoreLabel()
    }
    
    /// Loads Rebo and all of the bulls into the view
    public func loadCharactersInto(view: UIView){
        view.addSubview(rebo)
        for bull in bulls{
            view.addSubview(bull)
        }
    }
    
    /// Pauses and unpauses the game. Force Pause will force a pause = true
    func pause(forcePause: Bool){
        
        if (forcePause){
            BWGameField.paused = true
        }else{
            BWGameField.paused = !BWGameField.paused
        }
        
        pausedLabel.isHidden = !BWGameField.paused
        
        if (BWGameField.paused){
            BWGameField.gameTimer?.invalidate()
            BWGameField.doubleTap.numberOfTapsRequired = 1
        }else{
            // Kick off the game timer (effectively frame processes every tick)
            BWGameField.gameTimer = nil
            BWGameField.gameTimer = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(moveBulls), userInfo: nil, repeats: true)
            BWGameField.doubleTap.numberOfTapsRequired = 2
        }
    }
    
    // MARK: User Interaction Methods
    
    dynamic func handleDrag(panRecognizer: UIPanGestureRecognizer){
        if (panRecognizer.state == .began || panRecognizer.state == .changed) && rebo != nil{
            let translation = panRecognizer.translation(in: self)
            
            // As we have tied the pan recognizer to rebo panRecognizer.view references the rebo object
            let viewCenter = rebo.center
            let dx = rebo.get(dx: translation.x, viewWidth: self.frame.width)
            let dy = rebo.get(dy: translation.y, viewHeight: self.frame.height)
            
            // If Rebo is not being dragged outisde the bounds then we move him
            if BWGameField.gameTimer!.isValid{
                rebo.center = CGPoint(x: viewCenter.x + dx, y: viewCenter.y + dy)
                panRecognizer.setTranslation(.zero, in: self)
            }
        }
    }
    
    // MARK: Bull Moving Methods
    
    /// Called at every frame update.
    @objc func moveBulls(){
        processRound()
        bulls.forEach{ b in
            move(bull:b)
        }
    }
    
    func move(bull: Bull){
        
        let upper_limit: CGFloat = 5
        let lower_limit: CGFloat = 4
        
        // It is more efficient to update score label only when a bounce is detected, as opposed to every frame
        
        // Flip the sign of the x and y directions if the bull touches the pen bounds
        
        // Left of play area or right of play area
        if (bull.x + bull.dx - (bull.frame.width/2) < 4 ||
            CGFloat(bull.x + bull.dx + (bull.frame.width/2)) > self.frame.width - 4){
            
            bull.dx *= -1
            let randOffset = randRange(lower: -1, upper: 1)
            // Stops bulls moving horizontally or too slow/ fast
            if !(bull.dx + randOffset == 0){
                bull.dx += randOffset
            }
            
            if(bull.dx > upper_limit){
                bull.dx = BWCharacterStats.getBullSpeed()
            }else if(bull.dx < -upper_limit){
                bull.dx = BWCharacterStats.getBullSpeed() * -1
            }else if(bull.dx > -lower_limit && bull.dx < lower_limit){
                if (bull.dx < 0){
                    bull.dx = BWCharacterStats.getBullSpeed() * -1
                }else{
                    bull.dx = BWCharacterStats.getBullSpeed()
                }
            }
            
            bull.amountOfBounces += 1
            
            updateScoreLabel()
        }
        
        // Top of play area or bottom of play area
        if(bull.y + bull.dy - (bull.frame.height/2) < 4 ||
            CGFloat(bull.y + bull.dy + (bull.frame.height/2)) > self.frame.height - 4){
            
            bull.dy *= -1
            let randOffset = randRange(lower: -1, upper: 1)
            // Stops bulls moving vertically or too slow/ fast
            if !(bull.dy + randOffset == 0){
                bull.dy += randOffset
            }
            
            // Stops bull moving crazy fast
            if (bull.dy == bull.dx){ bull.dy -= 1 }
            
            if(bull.dy > upper_limit){
                bull.dy = BWCharacterStats.getBullSpeed()
            }else if(bull.dy < -upper_limit){
                bull.dy = BWCharacterStats.getBullSpeed() * -1
            }else if(bull.dy > -lower_limit && bull.dy < lower_limit){
                if (bull.dy < 0){
                    bull.dy = BWCharacterStats.getBullSpeed() * -1
                }else{
                    bull.dy = BWCharacterStats.getBullSpeed()
                }
            }
            
            bull.amountOfBounces += 1;
            
            updateScoreLabel()
        }
        
        // Update position of Bull
        bull.x += bull.dx
        bull.y += bull.dy
        bull.updatePosition(x: bull.x, y: bull.y)
    }
    
    func randRange(lower: Int , upper: Int) -> CGFloat {
        return CGFloat(lower + Int(arc4random_uniform(UInt32(upper - lower + 1))))
    }
    
    func randomIntFrom(start: Int, to end: Int) -> Int {
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
    }
    
    func processRound(){
        // Spawns a new bull everytime the most recently spawned bull has bounced over 7 times
        if bulls.last!.amountOfBounces > 9 && bulls.count < 8{
            spawnNewBull()
        }else{
            // Collision Detection 😏
            for bull in bulls {
                if rebo.frame.intersects(bull.frame) && bull.amountOfBounces > 0{
                    // Game Over.
                    gameEnded(state: .lost)
                }
            }
        }
    }
    
    // Spawns a new bull onto the field at a random position that is not occupied by Rebo
    func spawnNewBull(){
        let newBull = Bull(pos: self.getRandomPoisitonForBull())
        bulls.append(newBull)
        self.addSubview(newBull)
    }
    
    func getRandomPoisitonForBull() -> CGPoint {
        
        let bullSize = BWCharacterStats.getBullSize()
        
        var x = randomIntFrom(start: 4 + Int(bullSize.width), to: Int(self.frame.width) - Int(bullSize.width))
        var y = randomIntFrom(start: 4 + Int(bullSize.height), to: Int(self.frame.height) - Int(bullSize.height))
        
        // Generates a new position if a bull is spawned on top of Rebo
        while(rebo.frame.intersects(CGRect(x: x, y: y, width: 50, height: 50))){
            x = randomIntFrom(start: 4 + Int(bullSize.width), to: Int(self.frame.width) - Int(bullSize.width))
            y = randomIntFrom(start: 4 + Int(bullSize.height), to: Int(self.frame.height) - Int(bullSize.height))
        }
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: Scoring
    
    func currentScore() -> Int{
        if bulls != nil{
            return bulls.first!.amountOfBounces
        }
        return 0
    }
    
    // MARK: EndGame methods
    
    func gameEnded(state: BWGameState){
        // Stop the timer
        BWGameField.gameTimer!.invalidate()
        
        // Set / decide the high score
        var highScore = UserDefaults.standard.integer(forKey: BWHighScore)
        if currentScore() > highScore{
            highScore = currentScore()
            UserDefaults.standard.set(currentScore(), forKey: BWHighScore)
        }
        
        self.addGestureRecognizer(BWGameField.tap)
        self.removeGestureRecognizer(BWGameField.doubleTap)
        
        // Show the end game dialog
        showDialog(title: "Rebo was Eaten! ☹️",
                   message: "Rebo was taken by one of the mutated bulls!",
                   continueMessage: "Tap to Play Again",
                   showHighScore: true)
    }
    
    // MARK: Character Selection
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        if (BWGameField.currentPositionInReboArray! == reboArray.count-1){
            BWGameField.currentPositionInReboArray! = 0
        }else{
            BWGameField.currentPositionInReboArray! += 1
        }
        setCurrentSelectedRebo(basedOff: .iterative)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if (BWGameField.currentPositionInReboArray! == 0){
            BWGameField.currentPositionInReboArray! = reboArray.count-1
        }else{
            BWGameField.currentPositionInReboArray! -= 1
        }
        setCurrentSelectedRebo(basedOff: .iterative)
    }
    
    // Keeps track of the Rebo on the selection screen
    enum BWPointerType{
        case iterative
        case lastUnlockedCharacter
    }
    
    func setCurrentSelectedRebo(basedOff: BWPointerType){
        
        // Get the high score
        let highScore = UserDefaults.standard.integer(forKey: BWHighScore)
        
        // Get the current selected Rebo
        if (basedOff == .lastUnlockedCharacter){
            BWGameField.currentPositionInReboArray = BWGameField.lastUnlockedPositionInReboArray
        }
        let currentRebo = reboArray[BWGameField.currentPositionInReboArray]
        
        // Fetch the minimum score needed for the current selected Rebo
        let minimumScoreForCurrentRebo = BWCharacterStats.getMinimumScore(for: currentRebo)
        
        // Check if user has unlocked secret Rebo
        let hasUnlockedHatlessRebo = UserDefaults.standard.bool(forKey: BWHatlessReboUnlocked)
        
        // Gets the image for the selected Rebo
        lockedReboImage.image = BWCharacterStats.getReboImage(for: currentRebo)
        
        // If user is on hatless but hasnt unlocked it
        if currentRebo == .hatless && !hasUnlockedHatlessRebo{
            lockedReboImage.alpha = 0.1
            unlockedAtLabel.isHidden = false
            unlockedAtLabel.text = "Secret"
            
        // If user is on character that they have not unlocked
        }else if highScore < minimumScoreForCurrentRebo{
            lockedReboImage.alpha = 0.45
            unlockedAtLabel.isHidden = false
            unlockedAtLabel.text = "Unlocked after Level \(minimumScoreForCurrentRebo)"
            
        // If user is on character they are eligble for
        }else{
            unlockedAtLabel.isHidden = true
            lockedReboImage.alpha = 1.0
            BWGameField.currentRebo = currentRebo
            BWGameField.lastUnlockedPositionInReboArray = BWGameField.currentPositionInReboArray
        }
    }
}

var gameField: BWGameField!
