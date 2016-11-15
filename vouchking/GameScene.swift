//
//  GameScene.swift
//  CoinDropping
//
//  Created by Izzy on 19/10/2016.
//  Copyright (c) 2016 Izzy. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Block     : UInt32 = 0b1
    static let Coin      : UInt32 = 0b10
    static let Edge      : UInt32 = 0x1 << 3
}

let CoinCategoryName = "coin"
let BlockCategoryName = "block"


class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    //MARK: Properties
    var viewController: UIViewController?
    var coinCounter = 0
    var coin = SKSpriteNode(imageNamed: "coin")
    var block0 = SKSpriteNode(imageNamed: "17")
    var block1 = SKSpriteNode(imageNamed: "18")
    var panelDuration: TimeInterval = 1.0 //Its' bsically the speed
    
    var blockRightCount: Int = 0
    var blockLeftCount: Int = 0
    
    //MARK: GameScence Methods
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        createCoin()
        createBlocks()
        addSwipe()
        setupObservers()
        createBackground()
        print("NAME: \(GameViewController.instance.leftBusiness.businessName)")
        print("NAME: \(GameViewController.instance.rightBusiness.businessName)")
        // GameViewController.instance.resetPoints() //reset the total points earned
        
        //BAckground music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    //MARK: Off Screen MEthod
    override func update(_ currentTime: TimeInterval) {
        // Loop over all nodes in the scene
        self.enumerateChildNodes(withName: "*") {
            node, stop in
            if (node is SKSpriteNode) {
                if node.name == "coin"  {
                    let sprite = node as! SKSpriteNode
                    // Check if the node is not in the scene, then add a new coin
                    if (sprite.position.x < -sprite.size.width/2.0 || sprite.position.x > self.size.width+sprite.size.width/2.0
                        || sprite.position.y < -sprite.size.height/2.0 || sprite.position.y > self.size.height+sprite.size.height/2.0) {
                        self.coinCounter += 1
                        sprite.removeFromParent()
                        // Coin goes off screen, remove it, do the following methods
                        // Save points earned from the blocks
                        self.pointsEarnedTotal()
                        // Store previous points earned
                        GameViewController.instance.storePreviousPoints()
                        // GameViewController.instance.saveDataFromSession() This is now
                        // Randomise the objects
                        GameViewController.instance.setupBusinessPromotions()
                        self.createCoin() //start again, reset the scores
                        self.resetScores()
                        
                        //reset scores to 0
                    }
                }
            }
        }
    }
    
    //MARK: Contact Delegates
    func projectileDidCollideWithBlock(_ block:SKSpriteNode, coin:SKSpriteNode) {
        run(SKAction.playSoundFileNamed("goalScored.m4a", waitForCompletion: false))
        if let blockName = block.name {
            print("Name: \(blockName)")
            if blockName == "block0" {
                blockLeftCount += 2
            } else {
                blockRightCount += 2
            }
            
            print("Block Left Count: \(blockLeftCount)")
            print("Block Right Count: \(blockRightCount)")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1: Establish physics body for both of the body
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2: Dectecting the hit and calling the method to do with scores
        if ((firstBody.categoryBitMask & PhysicsCategory.Block != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Coin != 0)) {
            projectileDidCollideWithBlock(firstBody.node as! SKSpriteNode, coin: secondBody.node as! SKSpriteNode)
        }
    }
    
    //MARK: Panel/Block Helper Methods
    
    /**
     This method takes in a level variable as a parameter, it then sets speed by which the panel should move along the y axis.
     Its movement is manipulated by these speed levels and creates the illusion of a dynamic and ever changing panel speed, the 
     smaller the number the faster the panels speed
     */
    func reducePanelDuration(level: Int)-> TimeInterval  {
        
        switch level {
            case 1: panelDuration = 0.7
            case 2: panelDuration = 0.6
            case 3: panelDuration = 0.5
        default:
            panelDuration = 1 //default speed
        }
        
        return panelDuration
    }
    
    
    /**
     (Left Block) This method handles the physical movement of the Left block and takes in to account the panel duration, the action
     is repeated in order to established the up/down affect
     */
    func setLeftBlockMoveDown(_ panelDuration: TimeInterval) -> SKAction {
        
        let actionMoveDown = SKAction.moveTo(y: self.size.height, duration: panelDuration) //orginally set to 700/ 0
        let actionMoveUp = SKAction.moveTo(y: self.size.height - self.size.height, duration: panelDuration)
        let actionMoveDownUp = SKAction.sequence([actionMoveDown, actionMoveUp])
        let actionMoveDownRepeat = SKAction.repeatForever(actionMoveDownUp)
        
        return actionMoveDownRepeat
    }
    
    /**
     (Right Block) This method handles the physical movement of the Left block and takes in to account the panel duration, the action
     is repeated in order to established the up/down affect
     */
    func setRightBlockMoveUp(_ panelDuration: TimeInterval) -> SKAction {
        
        let rightActionMoveUp = SKAction.moveTo(y: size.height - size.height, duration: panelDuration)
        let rightActionMoveDown = SKAction.moveTo(y: size.height, duration: panelDuration)
        let actionUpDown = SKAction.sequence([rightActionMoveUp, rightActionMoveDown])
        let actionUpDownRepeat = SKAction.repeatForever(actionUpDown)
        
        return actionUpDownRepeat
    }
    
    func removeActionsOnBlocks() {
        block0.removeAction(forKey: "leftBlockMove")
        block1.removeAction(forKey: "rightBlockMove")
    }
    
    func moveBlocksRandomely(randomNumber number: (first: Int, second: Int)) {
        block0.run(setLeftBlockMoveDown(reducePanelDuration(level: number.first)), withKey: "newLeftPanelSpeed")
        block1.run(setRightBlockMoveUp(reducePanelDuration(level: number.second)), withKey: "newRightPanelSpeed")
    }
    
    //MARK: Helper Functions
    
    /**
     The method creates the swipping gesture functionality for up/down/right/left, the direction is then handled in separate method (handleSwipe).
     Everytime a swipe is regeistered, it stored it in array and then a method is called on a specific direction within that method
     */
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handleSwipe(_:)))
            gesture.direction = direction
            self.view!.addGestureRecognizer(gesture)
        }
    }
    
    /**
     This method handles the actual swipe direction, when the relevant direction is regsitred left/right then the coin is forced in that direction.
     The count is given an initial negative count because it will aid with scoring, so if the user misses then they are given -1 score, however if they
     score a hit then the points given +2, thus avoiding the hassle of a complex scoring mechanic because the +2 gets rids of -ve number and the use ends up with
     +1 (-1 + 2 = 1)
     */
    func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        let gestureDirection = sender.direction
        
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.right:
            print("RIGHT-Miss?")
            coin.removeAction(forKey: "downForever")
            let moveRight = SKAction.move(to: CGPoint(x: 3000,y: 450), duration:2.0) //orginally the values where 4000
            let actionMoveDone = SKAction.removeFromParent()
            coin.run(SKAction.sequence([moveRight, actionMoveDone]), withKey: "GoRightCoin")
            blockRightCount -= 1
            run(SKAction.playSoundFileNamed("hockeyStickSlap.mp3", waitForCompletion: false))

            
        case UISwipeGestureRecognizerDirection.left:
            print("LEFT-Miss?")
            coin.removeAction(forKey: "downForever")
            let moveLeft = SKAction.move(to: CGPoint(x: -3000,y: 450), duration:2.0)
            let actionMoveDone = SKAction.removeFromParent()
            coin.run(SKAction.sequence([moveLeft, actionMoveDone]), withKey: "GoLeftCoin")
            blockLeftCount -= 1
            run(SKAction.playSoundFileNamed("hockeyStickSlap.mp3", waitForCompletion: false))

            
        default:
            print("Gesture Direction Not Needed")
        }
    }
    
    /**
     Creates random Tuple Numbers that corrolate with the levels of speed for the panels, so for example if the random
     number brings back 3, this means level 3 of speed for the blocks will be used.
     */
    func randomTupleNumbers() -> (first: Int, second: Int) {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        let anotherRandomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        //        print("numbers: \(randomNumber) , \(anotherRandomNumber)")
        return (randomNumber, anotherRandomNumber)
    }
    
    //MARK: Create Sprites/Coin/ Blocks/ background
    /**
     A Coin assest is created, placed in the centre and a physics body is established so that when the coin colloides with the blocks
     it registers the intersection for late use in the scoring mechanic
     */
    func createCoin()  {
        print("create coin: \(coinCounter)")
        let newCoin = SKSpriteNode(imageNamed: "19")
        newCoin.name = CoinCategoryName
        newCoin.size = CGSize(width: 50, height: 50)
        newCoin.position = CGPoint(x: self.size.width/2, y: self.size.height) //drop coin in centre of screen
        newCoin.physicsBody = SKPhysicsBody.init(circleOfRadius: newCoin.size.width/2)
        newCoin.physicsBody?.friction = 0
        newCoin.physicsBody?.restitution = 1
        newCoin.physicsBody?.usesPreciseCollisionDetection = true
        newCoin.physicsBody?.affectedByGravity = false
        
        newCoin.zPosition = 1
        coin = newCoin
        
        addChild(newCoin)
        
        let actionMoveDownForever = SKAction.repeatForever(SKAction.moveTo(y: -100, duration: 3.0))
        let actionMoveDone = SKAction.removeFromParent()
        newCoin.run(SKAction.sequence([actionMoveDownForever, actionMoveDone]), withKey: "downForever")
    }
    
    /**
     Create the blocks(Left = block0, Right = block1) with their respective images, since this is created using a loop,
     a reference to a property is used for the movement of the blocks in order to abstract out the movement but to also make
     it easier to manipulate the blocks speed at certain levels of the game
     */
    
    func createBlocks()  {
        let numberOfBlocks = 2
        
        for i in 0..<numberOfBlocks {
            var block = SKSpriteNode(imageNamed: "18")//default image
            block.size = CGSize(width: 14, height: 80.0)
            
            if i == 0 {
                let texture = SKTexture(imageNamed: "17")
                block = SKSpriteNode(texture: texture)
                block.name = "block\(i)"
                //                block.name = GameViewController.instance.businessOneLeft.businessName
                print("block: Bottom Left: \(block.name)")
                block.position = CGPoint(x: (size.width - size.width) + 10, y: size.height - size.height) //bottom left, 10 + added to allow for paddle to be viewable
                block.run(setLeftBlockMoveDown(panelDuration), withKey: "leftBlockMove")
                block.zPosition = 1
                block0 = block // a way to reference the panel back to change its speed
                
            } else  {
                let texture = SKTexture(imageNamed: "18")
                block = SKSpriteNode(texture: texture)
                block.name = "block\(i)"
                print("block: Top Right: \(block.name)")
                block.position = CGPoint(x: (size.width) - 10, y: size.height) //top right, - 10 (minus) to allow for the paddle to be viewable
                block.run(setRightBlockMoveUp(panelDuration), withKey: "rightBlockMove")
                block.zPosition = 1
                block1 = block
            }
            
            //phsyics body setup
            block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
            block.physicsBody?.isDynamic = true
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Coin
            block.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            addChild(block)
        }
    }
    
    
    /**
     The background is a static sprite which is the same size as the scene area, the clock/timer also takes in to account the relative postion of the
     background to ensure that regardless of the device size it will position the assests/ sprite correctly
     */
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "no-clock")
        let clock = SKSpriteNode(imageNamed: "14")
        clock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        clock.size.height = 104
        clock.size.width = 90
        clock.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4)
        clock.zPosition = 0.5
        addChild(clock)
        
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.name = "background"
        //        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    //MARK: Observer Methods
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "gameOver"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.timeHasBeenDecreased), name:NSNotification.Name(rawValue: "timeHasBeenDecreased"), object: nil)
    }
    
    /**
     The timer method is called from the observer/target/action. The timer is set between four distint time parameters
     which calls a method that brings back a random blocks speed based on the number that is genreated from randomNumber generator.
     */
    
    func timeHasBeenDecreased() {
        // print("Time Went Down: \(GameViewController.instance.timerCount)"
        let number = randomTupleNumbers()
        
        switch GameViewController.instance.timerCount {
        case 18:
            removeActionsOnBlocks()
            moveBlocksRandomely(randomNumber: number)
        case 14:
            removeActionsOnBlocks()
            moveBlocksRandomely(randomNumber: number)
        case 10:
            removeActionsOnBlocks()
            moveBlocksRandomely(randomNumber: number)
        case 6:
            removeActionsOnBlocks()
            moveBlocksRandomely(randomNumber: number)
        default: break
        }
    }
    
    func methodOfReceivedNotification(_ notification: Notification){
        print("Game Over baby")
        //Tally up the scores here!
        pointsEarnedTotal()
        scene!.view?.isPaused = true
    }
    
    //MARK: Promotion Scores
    func pointsEarnedTotal()  {
        
        GameViewController.instance.leftBusiness.pointsEarned = blockLeftCount as NSNumber!
        GameViewController.instance.rightBusiness.pointsEarned = blockRightCount as NSNumber!
    }
    
    func resetScores()  {
        blockLeftCount = 0
        blockRightCount = 0
    }
    
}
