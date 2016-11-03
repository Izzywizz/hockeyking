//
//  GameScene.swift
//  BallDropping
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
    static let Ball      : UInt32 = 0b10
    static let Edge      : UInt32 = 0x1 << 3
}

let BallCategoryName = "ball"
let BlockCategoryName = "block"


class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    //MARK: Properties
    var viewController: UIViewController?
    var isFingerOnBall = false
    var ballCounter = 0
    var ball = SKSpriteNode(imageNamed: "ball")
    var block0 = SKSpriteNode(imageNamed: "17")
    var block1 = SKSpriteNode(imageNamed: "18")
    var panelDuration: NSTimeInterval = 1.0 //Its' bsically the speed
    
    
    var blockRightCount: Int = 0
    var blockLeftCount: Int = 0
    
    //MARK: GameScence Methods
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        createBall()
        createBlocks()
        addSwipe()
        setupObservers()
        createBackground()
        print("NAME: \(GameViewController.instance.leftBusiness.businessName)")
        print("NAME: \(GameViewController.instance.rightBusiness.businessName)")
        //        GameViewController.instance.resetPoints() //reset the total points earned
    }
    
    
    //MARK: Off Screen MEthod
    override func update(currentTime: CFTimeInterval) {
        // Loop over all nodes in the scene
        self.enumerateChildNodesWithName("*") {
            node, stop in
            if (node is SKSpriteNode) {
                if node.name == "ball"  {
                    let sprite = node as! SKSpriteNode
                    // Check if the node is not in the scene, then add a new ball
                    if (sprite.position.x < -sprite.size.width/2.0 || sprite.position.x > self.size.width+sprite.size.width/2.0
                        || sprite.position.y < -sprite.size.height/2.0 || sprite.position.y > self.size.height+sprite.size.height/2.0) {
                        self.ballCounter += 1
                        sprite.removeFromParent()
                        
                        //Coin goes off screen, do the following methods
                        //save points earned from the blocks
                        self.calculateTotalScores()
                        //store previous points earned
                        GameViewController.instance.storePreviousPoints()
                        //                        GameViewController.instance.saveDataFromSession() This is now
                        
                        //randomise the objects
                        GameViewController.instance.setupBusinessPromotions()
                        self.createBall() //start again, reset the scores
                        self.resetScores()
                        
                        //reset scores to 0
                    }
                }
            }
        }
    }
    
    //MARK: Contact Delegates
    func projectileDidCollideWithBlock(block:SKSpriteNode, ball:SKSpriteNode) {
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
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
            (secondBody.categoryBitMask & PhysicsCategory.Ball != 0)) {
            projectileDidCollideWithBlock(firstBody.node as! SKSpriteNode, ball: secondBody.node as! SKSpriteNode)
        }
    }
    
    //MARK: Panel/Block Helper Methods
    func reducePanelDuration(level level: Int)-> NSTimeInterval  {
        if level == 1 {
            panelDuration = 0.7
        } else if level == 2    {
            panelDuration = 0.5
        } else if level == 3    {
            panelDuration = 0.3
        } else  {
            panelDuration = 1
        }
        
        return panelDuration
    }
    
    func setLeftBlockMoveDown(panelDuration: NSTimeInterval) -> SKAction {
        
        let actionMoveDown = SKAction.moveToY(self.size.height, duration: panelDuration) //orginally set to 700/ 0
        let actionMoveUp = SKAction.moveToY(self.size.height - self.size.height, duration: panelDuration)
        let actionMoveDownUp = SKAction.sequence([actionMoveDown, actionMoveUp])
        let actionMoveDownRepeat = SKAction.repeatActionForever(actionMoveDownUp)
        
        return actionMoveDownRepeat
    }
    
    func setRightBlockMoveUp(panelDuration: NSTimeInterval) -> SKAction {
        
        let rightActionMoveUp = SKAction.moveToY(size.height - size.height, duration: panelDuration)
        let rightActionMoveDown = SKAction.moveToY(size.height, duration: panelDuration)
        let actionUpDown = SKAction.sequence([rightActionMoveUp, rightActionMoveDown])
        let actionUpDownRepeat = SKAction.repeatActionForever(actionUpDown)
        
        return actionUpDownRepeat
    }
    
    func removeActionsOnBlocks() {
        block0.removeActionForKey("leftBlockMove")
        block1.removeActionForKey("rightBlockMove")
    }
    
    func moveBlocksRandomely(randomNumber number: (Int, Int)) {
        block0.runAction(setLeftBlockMoveDown(reducePanelDuration(level: number.0)), withKey: "newLeftPanelSpeed")
        block1.runAction(setRightBlockMoveUp(reducePanelDuration(level: number.1)), withKey: "newRightPanelSpeed")
    }
    
    //MARK: Helper Functions
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handleSwipe(_:)))
            gesture.direction = direction
            self.view!.addGestureRecognizer(gesture)
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        let gestureDirection = sender.direction
        
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.Right:
            print("RIGHT")
            ball.removeActionForKey("downForever")
            let moveRight = SKAction.moveTo(CGPointMake(3000,450), duration:2.0) //orginally the values where 4000
            let actionMoveDone = SKAction.removeFromParent()
            ball.runAction(SKAction.sequence([moveRight, actionMoveDone]), withKey: "GoRightBall")
            blockRightCount -= 1
            
        case UISwipeGestureRecognizerDirection.Left:
            print("LEFT")
            ball.removeActionForKey("downForever")
            let moveLeft = SKAction.moveTo(CGPointMake(-3000,450), duration:2.0)
            let actionMoveDone = SKAction.removeFromParent()
            ball.runAction(SKAction.sequence([moveLeft, actionMoveDone]), withKey: "GoLeftBall")
            blockLeftCount -= 1
            
        //            block0.runAction(setLeftBlockMoveDown(2)) //experiement with variable random panel
        default:
            print("Gesture Direction Not Needed")
        }
    }
    
    func randomTupleNumbers() -> (Int, Int) {
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(4)
        let anotherRandomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(4)
        print("numbers: \(randomNumber) , \(anotherRandomNumber)")
        return (randomNumber, anotherRandomNumber)
    }
    
    //MARK: Create Sprites/Ball/ Blocks/ background
    func createBall()  {
        print("create ball: \(ballCounter)")
        let newBall = SKSpriteNode(imageNamed: "19")
        newBall.name = BallCategoryName
        newBall.size = CGSizeMake(50, 50)
        newBall.position = CGPoint(x: self.size.width/2, y: self.size.height) //drop ball in centre of screen
        newBall.physicsBody = SKPhysicsBody.init(circleOfRadius: newBall.size.width/2)
        newBall.physicsBody?.friction = 0
        newBall.physicsBody?.restitution = 1
        newBall.physicsBody?.usesPreciseCollisionDetection = true
        newBall.physicsBody?.affectedByGravity = false
        
        newBall.zPosition = 1
        ball = newBall
        
        addChild(newBall)
        
        let actionMoveDownForever = SKAction.repeatActionForever(SKAction.moveToY(-100, duration: 3.0))
        let actionMoveDone = SKAction.removeFromParent()
        newBall.runAction(SKAction.sequence([actionMoveDownForever, actionMoveDone]), withKey: "downForever")
    }
    
    
    func createBlocks()  {
        let numberOfBlocks = 2
        
        for i in 0..<numberOfBlocks {
            var block = SKSpriteNode(imageNamed: "18")//default image
            block.size = CGSizeMake(14, 80.0)
            
            if i == 0 {
                let texture = SKTexture(imageNamed: "17")
                block = SKSpriteNode(texture: texture)
                block.name = "block\(i)"
                //                block.name = GameViewController.instance.businessOneLeft.businessName
                print("block: Bottom Left: \(block.name)")
                block.position = CGPoint(x: (size.width - size.width) + 10, y: size.height - size.height) //bottom left, 10 + added to allow for paddle to be viewable
                block.runAction(setLeftBlockMoveDown(panelDuration), withKey: "leftBlockMove")
                block.zPosition = 1
                block0 = block // a way to reference the panel back to change its speed
                
            } else  {
                let texture = SKTexture(imageNamed: "18")
                block = SKSpriteNode(texture: texture)
                block.name = "block\(i)"
                print("block: Top Right: \(block.name)")
                block.position = CGPoint(x: (size.width) - 10, y: size.height) //top right, - 10 (minus) to allow for the paddle to be viewable
                block.runAction(setRightBlockMoveUp(panelDuration), withKey: "rightBlockMove")
                block.zPosition = 1
                block1 = block
            }
            //phsyics body setup
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
            block.physicsBody?.dynamic = true
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
            block.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            addChild(block)
        }
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "no-clock")
        let clock = SKSpriteNode(imageNamed: "14")
        clock.anchorPoint = CGPointMake(0.5, 0.5)
        clock.size.height = 104
        clock.size.width = 90
        clock.position = CGPointMake(self.frame.width/2, self.frame.height/4)
        clock.zPosition = 0.5
        addChild(clock)
        
        background.anchorPoint = CGPointMake(0.5, 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.name = "background"
        //        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    //MARK: Observer Methods
    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.methodOfReceivedNotification(_:)), name:"gameOver", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.timeHasBeenDecreased), name:"timeHasBeenDecreased", object: nil)
    }
    
    func timeHasBeenDecreased() {
        //        print("Time Went Down: \(GameViewController.instance.timerCount)"
        let number = randomTupleNumbers()
        
        switch GameViewController.instance.timerCount {
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
    
    func methodOfReceivedNotification(notification: NSNotification){
        print("Game Over baby")
        //Tally up the scores here!
        calculateTotalScores()
        scene!.view?.paused = true
    }
    
    //MARK: Promotion Scores
    func calculateTotalScores()  {
        
        GameViewController.instance.leftBusiness.pointsEarned = blockLeftCount
        GameViewController.instance.rightBusiness.pointsEarned = blockRightCount
    }
    
    func resetScores()  {
        blockLeftCount = 0
        blockRightCount = 0
    }
    
    
    
}
