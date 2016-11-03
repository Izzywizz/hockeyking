//
//  GameViewController.swift
//  BallDropping
//
//  Created by Izzy on 19/10/2016.
//  Copyright (c) 2016 Izzy. All rights reserved.
// Testing whether branch conversion

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    
    //MARK: Properties
    var timerCount = 20
    var clockTimer = NSTimer()
    var label: UILabel!
    static var instance: GameViewController!
    
    //One = Left business
    var leftBusiness: Promotion!
    var previousBusinessTotalPoints = 0
    var businessOneRandomNumber: Int = 0
    var leftResult = 0
    
    var businessTwoRandomNumber: Int = 0
    var rightBusiness: Promotion!
    var previousBusinessTwoTotalPoints = 0
    var rightResult = 0
    
    
    @IBOutlet weak var leftLogoImageView: UIImageView!
    @IBOutlet weak var rightLogoImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        rightLogoImageView.frame.origin.y = 20.0 // 20 down from the top
        rightLogoImageView.frame.origin.x = (self.view.bounds.size.width - rightLogoImageView.frame.size.width) / 2.0 // centered left to right
        leftLogoImageView.frame.origin.y = 20.0 // 20 down from the top
        leftLogoImageView.frame.origin.x = (self.view.bounds.size.width - leftLogoImageView.frame.size.width) / 2.0 // centered left to right
    }
    
    //MARK: UIVIew Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("New Game")
        GameViewController.instance = self //Allows shared access of ViewController to the GameSence
        setupBusinessPromotions()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        createLabel()
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window, The scene is not scaled to match the view. Instead, the scene is automatically resized so that its dimensions always matches those of the view. */
            //            skView.showsPhysics = true
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            scene.viewController = self
            scene.size = skView.bounds.size
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Promotion Methods
    func returnTwoObjects() -> (promotionOne: Promotion, promotionTwo: Promotion) {
        let dataArray = Data.sharedInstance().promotionsArray
        businessOneRandomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(dataArray.count) //create random number based on total array count
        let promotionOne = dataArray[businessOneRandomNumber] as! Promotion //grab the Promtion object based on the array value given by the random number
        businessTwoRandomNumber = checkUniqueRandomNumber(businessOneRandomNumber)
        let promotionTwo = dataArray[businessTwoRandomNumber] as! Promotion //create another random Promotion object but ensure that it is not the same object by ensuring that it is not the same random number
        
        return (promotionOne, promotionTwo)
        //        print("Array Object: \(promotionObject.facebook)")
    }
    
    func setupBusinessPromotions() {
        let promotions = returnTwoObjects()
        leftBusiness = promotions.0
        rightBusiness = promotions.1
        
        print("Promotion Object One: \(leftBusiness.businessName)") //left block/ logo/ promotion
        leftLogoImageView.image = leftBusiness.businessLogo
        print("Promotion Object Two: \(rightBusiness.businessName)")
        rightLogoImageView.image = rightBusiness.businessLogo
    }
    
    /**
     Functions that returns only a unique random number, this will be used to produce TWO unique Promotion objects
     */
    func checkUniqueRandomNumber(firstRandomNumber: Int) -> Int {
        
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(Data.sharedInstance().promotionsArray.count)
        if firstRandomNumber == randomNumber
        {
            //Random number generation, ensures
//            print("Same, FirstNumber: \(firstRandomNumber) and Second: \(randomNumber)")
//            print("call again")
            return checkUniqueRandomNumber(randomNumber)
        } else  {
//            print("DIFFERENT, FirstNumber: \(firstRandomNumber) and Second: \(randomNumber)")
            return randomNumber
        }
    }
    
    //MARK: Timer Methods/ Timer Label
    func countdown() {
        if timerCount > 0 {
            timerCount -= 1
            label.text = "\(timerCount)"
            NSNotificationCenter.defaultCenter().postNotificationName("timeHasBeenDecreased", object: self)
        } else {
            self.clockTimer.invalidate() //stop the clock
//            print("RandomNumberLeft: \(businessOneRandomNumber) RandomNumberRight: \(businessTwoRandomNumber)")
            NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: self)
            moveToGameSummary()
//            saveDataFromSession()
        }
    }
    
    func createLabel() {
        //create label
        label = UILabel(frame: CGRectZero)
        label.text = "\(timerCount)"
        label.font = UIFont(name: "LuckiestGuy-Regular", size: 32.0)
        label.textColor = UIColor(colorLiteralRed: 46/255.0, green: 117/255.0, blue: 161/255.0, alpha: 1)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal,
                                                 toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 78.5)
        label.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal,
                                                  toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 37.5)
        label.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: (self.view.frame.height/4) + 10)
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }

    
    //MARK: Helper Methods
    func moveToGameSummary()  {
        let gameSummaryVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromotionsTableViewController") as! PromotionsTableViewController
        gameSummaryVC.backButton.tag = 1
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.pushViewController(gameSummaryVC, animated: false)
    }
    
    //MARK: Save Session Data
    func storePreviousPoints() {
        let business = Data.sharedInstance().promotionsArray[businessOneRandomNumber] as! Promotion
        let businessTwo = Data.sharedInstance().promotionsArray[businessTwoRandomNumber] as! Promotion
        previousBusinessTotalPoints = Int (business.totalPoints)
        previousBusinessTwoTotalPoints = Int (businessTwo.totalPoints)
        
        leftResult = Int(business.totalPointsEarnedPerRound)
        rightResult = Int(businessTwo.totalPointsEarnedPerRound)
        
        print("Previous Total Points (L) \(business.businessName) Points: \(previousBusinessTotalPoints)")
        print("Previous Total Points (R)  \(businessTwo.businessName) Points: \(previousBusinessTwoTotalPoints)")
        
        saveDataFromSession()
    }
    
    func saveDataFromSession() {
        let result = Int(leftBusiness.pointsEarned) + previousBusinessTotalPoints // current points earned from the game session just played + the total from the actual business
        leftBusiness.totalPoints = result
        
        let resultTwo = Int(rightBusiness.pointsEarned) + previousBusinessTwoTotalPoints
        rightBusiness.totalPoints = resultTwo

        let total = leftResult + Int(leftBusiness.pointsEarned)
        leftBusiness.totalPointsEarnedPerRound = total
        let totalTwo = rightResult + Int(rightBusiness.pointsEarned)
        rightBusiness.totalPointsEarnedPerRound = totalTwo
        
        print("Points Earned Total (L): \(leftBusiness.businessName) Points Earned \(leftBusiness.totalPointsEarnedPerRound)")
        print("Points Earned Total (R): \(rightBusiness.businessName) Points Earned \(rightBusiness.totalPointsEarnedPerRound)")

        //Save instance of Data
        Data.sharedInstance().promotionsArray.replaceObjectAtIndex(businessOneRandomNumber, withObject: leftBusiness)
        Data.sharedInstance().promotionsArray.replaceObjectAtIndex(businessTwoRandomNumber, withObject: rightBusiness)
        print("(Points LEFT) Business: \(Data.sharedInstance().promotionsArray[businessOneRandomNumber].businessName) Total Points Earned: \(Data.sharedInstance().promotionsArray[businessOneRandomNumber].pointsEarned)")
        print("(Points RIGHT) Business: \(Data.sharedInstance().promotionsArray[businessTwoRandomNumber].businessName) Total Points Earned: \(Data.sharedInstance().promotionsArray[businessTwoRandomNumber].pointsEarned)")
        
    }
    

    
}
