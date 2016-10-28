//
//  GameViewController.swift
//  BallDropping
//
//  Created by Izzy on 19/10/2016.
//  Copyright (c) 2016 Izzy. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    
    //MARK: Properties
    var timerCount = 10
    var clockTimer = NSTimer()
    var label: UILabel!
    static var instance: GameViewController!
    
    var businessOneLeft: Promotion!
    var previousBusinessPointsOne = 0
    var businessOneRandomNumber: Int = 0
    
    var businessTwoRandomNumber: Int = 0
    var businessTwoRight: Promotion!
    var previousBusinessPointsTwo = 0
    
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
        GameViewController.instance = self
        setupBusinessPromotions()
        storePreviousPoints()
        //find previous scores
        
        //reset all points earend

        
//        setupBusinessPromotions()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //        timer.text = "\(timerCount)"
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
        businessOneLeft = promotions.0
        businessTwoRight = promotions.1
        
        print("Promotion Object One: \(businessOneLeft.businessName)") //left block/ logo/ promotion
        leftLogoImageView.image = businessOneLeft.businessLogo
        print("Promotion Object Two: \(businessTwoRight.businessName)")
        rightLogoImageView.image = businessTwoRight.businessLogo
    }
    
    /**
     Functions that returns only a unique random number, this will be used to produce TWO unique Promotion objects
     */
    func checkUniqueRandomNumber(firstRandomNumber: Int) -> Int {
        
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(Data.sharedInstance().promotionsArray.count)
        if firstRandomNumber == randomNumber
        {
            print("Same, FirstNumber: \(firstRandomNumber) and Second: \(randomNumber)")
            print("call again")
            return checkUniqueRandomNumber(randomNumber)
        } else  {
            print("DIFFERENT, FirstNumber: \(firstRandomNumber) and Second: \(randomNumber)")
            return randomNumber
        }
    }
    
    //MARK: Helper Functions
    func countdown() {
        if timerCount > 0 {
            timerCount -= 1
            label.text = "\(timerCount)"
        } else {
            self.clockTimer.invalidate() //stop the clock
//            print("RandomNumberLeft: \(businessOneRandomNumber) RandomNumberRight: \(businessTwoRandomNumber)")
            NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: self)
//            self.performSegueWithIdentifier("GoToTimesUp", sender: self)
            moveToGameSummary()
            saveDataFromSession()
            
        }
    }
    
    func moveToGameSummary()  {
        let gameSummaryVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromotionsTableViewController") as! PromotionsTableViewController
        gameSummaryVC.backButton.tag = 1
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.pushViewController(gameSummaryVC, animated: false)
    }
    
    func storePreviousPoints() {
        let business = Data.sharedInstance().promotionsArray[businessOneRandomNumber] as! Promotion
        business.pointsEarned = 0 //get rid of the previous adding of points earned
        let businessTwo = Data.sharedInstance().promotionsArray[businessTwoRandomNumber] as! Promotion
        businessTwo.pointsEarned = 0
        previousBusinessPointsOne = Int (business.totalPoints)
        previousBusinessPointsTwo = Int (businessTwo.totalPoints)
        print("Hardcoded \(business.businessName) (Points: \(previousBusinessPointsOne)")
        print("Hardcoded \(businessTwo.businessName) (Points: \(previousBusinessPointsTwo)")
    }
    
    func saveDataFromSession() {
        
        var result = Int(businessOneLeft.pointsEarned) // cuurent points earned from the game
        result += previousBusinessPointsOne // previous business points earned for that specific business
        print("RESULT \(businessOneLeft.businessName): \(result)")
        businessOneLeft.totalPoints = result
        
        var resultTwo = Int(businessTwoRight.pointsEarned) // points earned from the game
        resultTwo += previousBusinessPointsTwo // previous business points earned for that specific business
        print("RESULT \(businessTwoRight.businessName): \(resultTwo)")
        businessTwoRight.totalPoints = resultTwo
        
        //Save instance of Data
        Data.sharedInstance().promotionsArray.replaceObjectAtIndex(businessOneRandomNumber, withObject: businessOneLeft)
        Data.sharedInstance().promotionsArray.replaceObjectAtIndex(businessTwoRandomNumber, withObject: businessTwoRight)
        print("(Points Earned AFTER - LEFT) Business: \(Data.sharedInstance().promotionsArray[businessOneRandomNumber].businessName) Points Earned: \(Data.sharedInstance().promotionsArray[businessOneRandomNumber].pointsEarned)")
        print("(Points Earned AFTER - RIGHT) Business: \(Data.sharedInstance().promotionsArray[businessTwoRandomNumber].businessName) Points Earned: \(Data.sharedInstance().promotionsArray[businessTwoRandomNumber].pointsEarned)")
        
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
    
    
    
}
