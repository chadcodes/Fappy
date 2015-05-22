//
//  GameScene.swift
//  Flappy
//
//  Created by bitmaker on 2015-05-20.
//  Copyright (c) 2015 chad. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background = Background()
    
//    var _self = self

    // Collision detection, bitwise operators?
    let playerCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    
    // Count player taps
    var taps:Int = 0
    
    // Set score
    var score:Int = 0
    
    // Set wall speed
    var wallSpeed:Double = 150

    // Player character Node
    var player = SKSpriteNode()
    
    // Add background music player
    var backgroundMusic = AVAudioPlayer()
    
    // Add score label
    var scoreLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Setup the physics contact delegate
        // This fires on any contact
        self.physicsWorld.contactDelegate = self
        
        // Initialize the scene
//        self.initStartScene()

        // Initialize the scene
         self.initFappyScene()
    }
    
    // Start screen
    func initStartScene() {
        
    }
    
    // Creates the Fappy scene
    func initFappyScene() {

        // Create the player as a global
        self.player = createPlayer()
        
        // Add the player to the view
        self.addChild(player)
        
        // Add the ground as a local
        // params: x, y
        let ground = createBoundary(CGFloat(0), y: CGFloat(20))
        self.addChild(ground)

        // Add the ceiling as a local
        let ceiling = createBoundary(CGFloat(0), y: CGFloat(self.frame.height - 20))
        self.addChild(ceiling)
        
        // Start the game Sound
        backgroundMusic = self.setupAudioPlayerWithFile("808DubBeat", type: "wav")
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        
        // Add the score
        createScoreBoard()
        
        // Add the walls
        createWalls()
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("createWalls"), userInfo: nil, repeats: true)

        // Add the backgrounds
        // params: image, velocity, zindex, view
        background.addBackground1(SKTexture(imageNamed: "fappy_bg_02.png"), velocity: Double(30), zindex: CGFloat(1), view:self)

        background.addBackground2(SKTexture(imageNamed: "fappy_bg_03.png"), velocity: Double(12), zindex: CGFloat(2), view:self)
        
        // Add static bg
        var staticBgTexture = SKTexture(imageNamed: "fappy_bg_01.png")
        var staticBg = SKSpriteNode(texture: staticBgTexture)
        staticBg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        staticBg.zPosition = 0
        self.addChild(staticBg)
    }
    
    func createScoreBoard() {
        self.scoreLabel.fontName = "chalkduster"
        self.scoreLabel.fontSize = 100
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height - 150)
        self.scoreLabel.zPosition = 11
        self.scoreLabel.text = "0"
        self.addChild(scoreLabel)
    }
    
    func updateScore() {
        self.scoreLabel.text = String(taps)
    }
    
    func increaseScore() {
        score += 1
    }
    
    //
    func countTaps() {
        taps += 1
        updateScore()
    }
    
    // Create the player node. This returns an SKSpriteNode. The
    // player is an object and will need to be added to the scene.
    func createPlayer() -> SKSpriteNode {
        
        // Add player frames
        let playerTexture1 = SKTexture(imageNamed: "flappy1.png")
        let playerTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        // Create player animation
        let animation = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.1)
        let makePlayerAnimate = SKAction.repeatActionForever(animation)
        
        // Assign texture
        let player = SKSpriteNode(texture: playerTexture1)
        
        // Add position on screen
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        // Physics properties
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/2)
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.allowsRotation = false
        
        // Run the animation
        player.runAction(makePlayerAnimate)
        
        // zIndex for the character
        player.zPosition = 10
        
        // Return the player as an SKSpriteNode object
        return player
    }
    
    // Create a game boundary
    func createBoundary(x:CGFloat, y:CGFloat) -> SKSpriteNode {
        
        // Create boundary node
        let boundary = SKSpriteNode()
        
        // Define boundary position
        boundary.position = CGPointMake(x, y)
        
        // Set boundary physics body
        boundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width * 2, 1))
        
        // Setup collision detection
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.usesPreciseCollisionDetection = true
        boundary.physicsBody?.categoryBitMask = wallCategory
        boundary.physicsBody?.collisionBitMask = wallCategory | playerCategory
        boundary.physicsBody?.contactTestBitMask = wallCategory | playerCategory
        
        // Return the boundary as an SKSpriteNode object
        return boundary
    }
    
    // Create the walls
    func createWalls() {
        
        // create the gap height bigger than the player
        let gapHeight = player.size.height * 4.3
        
        var moveWallsLeft = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width / CGFloat(wallSpeed)))
        var removeWall = SKAction.removeFromParent()
        var moveAndRemove = SKAction.repeatActionForever(SKAction.sequence([moveWallsLeft, removeWall]))
        var movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        var wallOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        var wallTexture1 = SKTexture(imageNamed: "pipe1.png")
        var wall1 = SKSpriteNode(texture: wallTexture1)
        wall1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + (wall1.size.height/2) + ( gapHeight / 2 ) + wallOffset)
        wall1.runAction(moveAndRemove)
        
        wall1.physicsBody = SKPhysicsBody(rectangleOfSize: wall1.size)
        wall1.physicsBody?.dynamic = false
        wall1.physicsBody?.categoryBitMask = wallCategory
        wall1.zPosition = 5
        self.addChild(wall1);
        
        var wallTexture2 = SKTexture(imageNamed: "pipe2.png")
        var wall2 = SKSpriteNode(texture: wallTexture2)
        wall2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: (CGRectGetMidY(self.frame) - wall2.size.height / 2 - gapHeight/2 + wallOffset))
        wall2.runAction(moveAndRemove)
        
        wall2.physicsBody = SKPhysicsBody(rectangleOfSize: wall2.size)
        wall2.physicsBody?.dynamic = false
        wall2.physicsBody?.categoryBitMask = wallCategory
        wall2.zPosition = 5
        self.addChild(wall2);
        
//        println("Wall 1: \(wall1.position)")
        
        
        
    }
    
    /* Audio stuff */
    // Returns an AVAudioPlayer object
    // params: filename, type/extension
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        return audioPlayer!
    }
    
    /* Physics Begin Contact */
    // Called automatically when 2 objects begin contact
    func didBeginContact(contact: SKPhysicsContact) {
        
        // If contact was made between the wall or the player
        if (contact.bodyA.categoryBitMask == wallCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            println("contact made")
        }
    }
    
    /* Physics End Contact */
    // Called automatically when 2 objects end contact
    func didEndContact(contact: SKPhysicsContact) {
        
        // Called automatically when 2 objects end contact
        // If contact was ended between the wall or the player
        if (contact.bodyA.categoryBitMask == wallCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            println("contact ended")
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        // add to the tap counter
        countTaps()
        
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 60))
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
