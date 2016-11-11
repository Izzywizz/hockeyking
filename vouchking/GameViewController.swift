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
    var clockTimer = Timer()
    var label: UILabel!
    static var instance: GameViewController!
    
    //One = Left business
    var leftBusiness: Promotion!
    var previousLeftBusinessTotalPoints = 0
    var businessLeftRandomNumber: Int = 0
    var leftPointsEarnedPerRound = 0 //initially these values are setup as 0 in
    
    var businessRightRandomNumber: Int = 0
    var rightBusiness: Promotion!
    var previousRightBusinessTotalPoints = 0
    var rightResultEarnedPerRound = 0
    
    let negativeScoreLimit = -100//limit for scores
    
    @IBOutlet weak var leftLogoImageView: UIImageView!
    @IBOutlet weak var rightLogoImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        clockTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window, The scene is not scaled to match the view. Instead, the scene is automatically resized so that its dimensions always matches those of the view. */
            //            skView.showsPhysics = true
            scene.scaleMode = SKSceneScaleMode.resizeFill
            scene.viewController = self
            scene.size = skView.bounds.size
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //MARK: Promotion Methods
    func returnTwoObjects() -> (promotionOne: Promotion, promotionTwo: Promotion) {
        let dataArray = Data.sharedInstance().promotionsArray
        businessLeftRandomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: (dataArray?.count)!) //create random number based on total array count
        let promotionOne = dataArray?[businessLeftRandomNumber] as! Promotion //grab the Promtion object based on the array value given by the random number
        businessRightRandomNumber = checkUniqueRandomNumber(businessLeftRandomNumber)
        let promotionTwo = dataArray?[businessRightRandomNumber] as! Promotion //create another random Promotion object but ensure that it is not the same object by ensuring that it is not the same random number
        
        return (promotionOne, promotionTwo)
        //        print("Array Object: \(promotionObject.facebook)")
    }
    
    func setupBusinessPromotions() {
        let promotions = returnTwoObjects()
        leftBusiness = promotions.promotionOne
        rightBusiness = promotions.promotionTwo
        
        print("Promotion Object One: \(leftBusiness.businessName)") //left block/ logo/ promotion
        leftLogoImageView.image = leftBusiness.businessLogo
        print("Promotion Object Two: \(rightBusiness.businessName)")
        rightLogoImageView.image = rightBusiness.businessLogo
    }
    
    /**
     Functions that returns only a unique random number, this will be used to produce TWO unique Promotion objects
     */
    func checkUniqueRandomNumber(_ firstRandomNumber: Int) -> Int {
        
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: Data.sharedInstance().promotionsArray.count)
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: "timeHasBeenDecreased"), object: self)
        } else {
            self.clockTimer.invalidate() //stop the clock
            //            print("RandomNumberLeft: \(businessLeftRandomNumber) RandomNumberRight: \(businessRightRandomNumber)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gameOver"), object: self)
            moveToGameSummary()
            //            saveDataFromSession()
        }
    }
    
    func createLabel() {
        //create label
        label = UILabel(frame: CGRect.zero)
        label.text = "\(timerCount)"
        label.font = UIFont(name: "LuckiestGuy-Regular", size: 32.0)
        label.textColor = UIColor(colorLiteralRed: 46/255.0, green: 117/255.0, blue: 161/255.0, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 78.5)
        label.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.5)
        label.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: (self.view.frame.height/4) + 10)
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }
    
    
    //MARK: Helper Methods
    func moveToGameSummary()  {
        let gameSummaryVC = self.storyboard?.instantiateViewController(withIdentifier: "PromotionsTableViewController") as! PromotionsTableViewController
        gameSummaryVC.backButton.tag = 1
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(gameSummaryVC, animated: false)
    }
    
    //MARK: Save Session Data
    
    /**
     Obtain the scores from the Left and Right Business 
     */
    func storePreviousPoints() {
        let business = Data.sharedInstance().promotionsArray[businessLeftRandomNumber] as! Promotion
        let businessTwo = Data.sharedInstance().promotionsArray[businessRightRandomNumber] as! Promotion
        previousLeftBusinessTotalPoints = Int (business.totalPoints)
        previousRightBusinessTotalPoints = Int (businessTwo.totalPoints)
        
        leftPointsEarnedPerRound = Int(business.totalPointsEarnedPerRound)
        rightResultEarnedPerRound = Int(businessTwo.totalPointsEarnedPerRound)
        
        print("Previous Total Points (L) \(business.businessName) Points: \(previousLeftBusinessTotalPoints)")
        print("Previous Total Points (R)  \(businessTwo.businessName) Points: \(previousRightBusinessTotalPoints)")
        
        saveDataFromSession()
    }
    
    func saveDataFromSession() {
        
        let result = Int(leftBusiness.pointsEarned) + previousLeftBusinessTotalPoints // current points earned from the game session just played + the total from the actual business
        leftBusiness.totalPoints = result as NSNumber!
        
        let resultTwo = Int(rightBusiness.pointsEarned) + previousRightBusinessTotalPoints
        rightBusiness.totalPoints = resultTwo as NSNumber!
        
        let total = leftPointsEarnedPerRound + Int(leftBusiness.pointsEarned)
        leftBusiness.totalPointsEarnedPerRound = total as NSNumber!
        let totalTwo = rightResultEarnedPerRound + Int(rightBusiness.pointsEarned)
        rightBusiness.totalPointsEarnedPerRound = totalTwo as NSNumber!
        
        print("Points Earned Total (L): \(leftBusiness.businessName) Points Earned \(leftBusiness.totalPointsEarnedPerRound)")
        print("Points Earned Total (R): \(rightBusiness.businessName) Points Earned \(rightBusiness.totalPointsEarnedPerRound)")
        
        handleNegativeLimit(isLeftBlock: true, totalBusinessPoints: Int(leftBusiness.totalPoints))
        handleNegativeLimit(isLeftBlock: false, totalBusinessPoints: Int(rightBusiness.totalPoints))
        
        //Save instance of Data
        Data.sharedInstance().promotionsArray.replaceObject(at: businessLeftRandomNumber, with: leftBusiness)
        Data.sharedInstance().promotionsArray.replaceObject(at: businessRightRandomNumber, with: rightBusiness)
        print("(Points LEFT) Business: \((Data.sharedInstance().promotionsArray[businessLeftRandomNumber] as AnyObject).businessName) Total Points Earned: \((Data.sharedInstance().promotionsArray[businessLeftRandomNumber] as AnyObject).pointsEarned)")
        print("(Points RIGHT) Business: \((Data.sharedInstance().promotionsArray[businessRightRandomNumber] as AnyObject).businessName) Total Points Earned: \((Data.sharedInstance().promotionsArray[businessRightRandomNumber] as AnyObject).pointsEarned)")
        
    }
    
    /**
     Set the limit to the score preventing the game from adding anymore negative numbers to the score until their is a postive result
     */
    func handleNegativeLimit(isLeftBlock: Bool, totalBusinessPoints: Int) {
        if isLeftBlock {
            
            if negativeScoreLimit >= totalBusinessPoints{
                leftBusiness.totalPoints = negativeScoreLimit as NSNumber!
                leftBusiness.negativeLimitReached = true
            } else  {
                leftBusiness.negativeLimitReached = false
            }
        } else  {
            if negativeScoreLimit >= totalBusinessPoints{
                rightBusiness.totalPoints = negativeScoreLimit as NSNumber!
                rightBusiness.negativeLimitReached = true
            } else  {
                rightBusiness.negativeLimitReached = false
            }
        }
    }
    
    
    
}
