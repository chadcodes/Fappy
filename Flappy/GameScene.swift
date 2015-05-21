//
//  GameScene.swift
//  Flappy
//
//  Created by bitmaker on 2015-05-20.
//  Copyright (c) 2015 chad. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {

    enum BodyType:UInt32 {
        case wall = 1
        case ground = 2
        case player = 3
    }
    
    let playerCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    
    // Player character Node
    var player = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // setup the contact delegate
        physicsWorld.contactDelegate = self
        
        // add the bird
        self.createPlayer()
        
        // add the ground
        // params: top, bottom
        self.createBounds(CGFloat(20), bottom: CGFloat(20))

        // add the background
        // params: bg image, velocity, zindex
        self.addBackground(SKTexture(imageNamed: "bg.png"), velocity: Double(9), zindex: CGFloat(1))
    }
    
    // create the bird method
    func createPlayer() {
        
        // Add character frames
        let playerTexture1 = SKTexture(imageNamed: "flappy1.png")
        let playerTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        // Create animation
        let animation = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.1)
        let makePlayerAnimate = SKAction.repeatActionForever(animation)
        
        // Assign texture
        player = SKSpriteNode(texture: playerTexture1)
        
        // Add position on screen
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        // Run the animation
        player.runAction(makePlayerAnimate)
        
        // Physics properties
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/2)
        //        player.physicsBody?.dynamic = true
        //        player.physicsBody?.allowsRotation = false
        //        player.physicsBody?.categoryBitMask = BodyType.ground.toRaw()
        
        // Add character body
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (playerTexture1.size().width / 2))
        body.dynamic = true
        body.categoryBitMask = BodyType.player.toRaw()
        self.physicsBody = body
        body.collisionBitMask = BodyType.ground.toRaw()
        body.contactTestBitMask = BodyType.ground.toRaw()
        
        // zIndex for the character
        player.zPosition = 10
        
        self.addChild(player)
    }
    
    // Physics Contact
    func didBeginContact(contact: SKPhysicsContact) {
        // called automatically with 2 objects begin contact
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyA.categoryBitMask
        
        switch(contactMask) {
            case BodyType.ground.toRaw():
            // either the contactMask was the ground or the wall
            println("contact")
            default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        // called automatically with 2 objects end contact

    }
    
    
    
    // create game bounds
    func createBounds(top:CGFloat, bottom:CGFloat) {
        // Define ceiling
        let ceiling = SKNode()
        ceiling.position = CGPointMake(0, self.frame.height - top)
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width * 2, 1))
        ceiling.physicsBody?.dynamic = false
        self.addChild(ceiling)
        // Define ground
        let ground = SKNode()
        ground.position = CGPointMake(0, bottom)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width * 2, 1))
        // make sure the ground doesn't move
        ground.physicsBody?.dynamic = false
        // add the ground to our scene
        self.addChild(ground)
    }

    // method for infinite scrolling BG
    func addBackground(background:SKTexture, velocity:Double, zindex:CGFloat) {
        // define the background texture
        let backgroundTexture = background
        // move the bg from right to left
        var shiftBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: velocity)
        var replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        var movingAndReplacingBackground = SKAction.repeatActionForever(SKAction.sequence([shiftBackground, replaceBackground]))
        // piece 3 copies of the BG together
        for var i:CGFloat = 0; i<3; i++ {
            // define bg, give it a height and moving width
            var background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + (backgroundTexture.size().width * i), y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.runAction(movingAndReplacingBackground)
            background.zPosition = zindex
            self.addChild(background)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 60))
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
//            if location == player.position {
//                println()
//            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
