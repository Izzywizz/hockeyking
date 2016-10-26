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
    var arrayCount: Int!
    var timerCount = 10
    var clockTimer = NSTimer()
    var label: UILabel!
    
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
        arrayCount = Data.sharedInstance().promotionsArray.count
        setupBusinessPromotions()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //        timer.text = "\(timerCount)"
        createLabel()
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.countdown), userInfo: nil, repeats: true)
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
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
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(dataArray.count) //create random number based on total array count
        let promotionOne = dataArray[randomNumber] as! Promotion //grab the Promtion object based on the array value given by the random number
        let promotionTwo = dataArray[checkUniqueRandomNumber(randomNumber)] as! Promotion //create another random Promotion object but ensure that it is not the same object by ensuring that it is not the same random number
        
        return (promotionOne, promotionTwo)
        //        print("Array Object: \(promotionObject.facebook)")
    }
    
    func setupBusinessPromotions() {
        let promotions = returnTwoObjects()
        let businessOnTheLeft = promotions.0
        let businessOnTheRight = promotions.1
        
        print("Promotion Object One: \(businessOnTheLeft.businessName)") //left block/ logo/ promotion
        leftLogoImageView.image = businessOnTheLeft.businessLogo
        print("Promotion Object Two: \(businessOnTheRight.businessName)")
        rightLogoImageView.image = businessOnTheRight.businessLogo
    }
    
    /**
     Functions that returns only a unique random number, this will be used to produce TWO unique Promotion objects
     */
    func checkUniqueRandomNumber(firstRandomNumber: Int) -> Int {
        
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(arrayCount)
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
            self.clockTimer.invalidate()
            print("FINSHED")
            NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: self)
//            NSNotificationCenter.defaultCenter().postNotificationName("FinalScores", object: self)            
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
    
    
    
}
