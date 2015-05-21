//
//  GameScene.swift
//  Flappy
//
//  Created by bitmaker on 2015-05-20.
//  Copyright (c) 2015 chad. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Collision detection, bitwise operators?
    let playerCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    
    // Player character Node
    var player = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Setup the physics contact delegate
        // This fires on any contact
        self.physicsWorld.contactDelegate = self
        
        // Initialize the scene
        self.initFappyScene()
    }
    
    // Creates the Fappy scene
    func initFappyScene() {

        // Create the player as a global
        self.player = createPlayer()
        
        // Add the player to the view
        self.addChild(player)
        
        // Add the ground as a local
        // params: x, y
        let ground = createBoundary(CGFloat(0), bottom: CGFloat(20))
        self.addChild(ground)

        // Add the ceiling as a local
        let ceiling = createBoundary(CGFloat(0), bottom: CGFloat(self.frame.height - 20))
        self.addChild(ceiling)
        
        // Add the background as a local
        // params: bg image, velocity, zindex
        addBackground(SKTexture(imageNamed: "bg.png"), velocity: Double(9), zindex: CGFloat(1))
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
        
        // Run the animation
        player.runAction(makePlayerAnimate)
        
        // zIndex for the character
        player.zPosition = 10
        
        // Return the player as an object
        return player
    }
    
    // Create a game boundary
    func createBoundary(top:CGFloat, bottom:CGFloat) -> SKSpriteNode {
        
        // Create boundary node
        let boundary = SKSpriteNode()
        
        // Define boundary position
        boundary.position = CGPointMake(top, bottom)
        
        // Set boundary physics body
        boundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width * 2, 1))
        
        // Setup collision detection
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.usesPreciseCollisionDetection = true
        boundary.physicsBody?.categoryBitMask = wallCategory
        boundary.physicsBody?.collisionBitMask = wallCategory | playerCategory
        boundary.physicsBody?.contactTestBitMask = wallCategory | playerCategory
        
        // Return the boundary as an object
        return boundary
    }

    // Method for infinite scrolling BG
    func addBackground(background:SKTexture, velocity:Double, zindex:CGFloat) {
        
        // Define the background texture
        let backgroundTexture = background
        
        // Move the bg from right to left
        var shiftBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: velocity)
        var replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        var movingAndReplacingBackground = SKAction.repeatActionForever(SKAction.sequence([shiftBackground, replaceBackground]))
        
        // Piece 3 copies of the BG together
        for var i:CGFloat = 0; i<3; i++ {
            
            // Define bg, give it a height and moving width
            var background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + (backgroundTexture.size().width * i), y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.runAction(movingAndReplacingBackground)
            background.zPosition = zindex
            self.addChild(background)
        }
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
        
        // Called automatically with 2 objects end contact
        // If contact was made between the wall or the player
        if (contact.bodyA.categoryBitMask == wallCategory) && (contact.bodyB.categoryBitMask == playerCategory) {
            println("contact ended")
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 100))
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
