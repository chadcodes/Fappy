//
//  GameScene.swift
//  Flappy
//
//  Created by bitmaker on 2015-05-20.
//  Copyright (c) 2015 chad. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Player character Node
    var player = SKSpriteNode()
    
    // Background Node
    var bg = SKSpriteNode()
        
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // add the bird
        self.createPlayer()
        
        // add the ground
        self.createGround()
        
        // add the background
        self.moveBackground()
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
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        
        // zIndex for the character
        player.zPosition = 10
        
        self.addChild(player)
    }
    
    // create background method
    func createBackground() {
        //
        
    }
    
    // create ground method
    func createGround() {
        // Define the ground
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        // make sure the ground doesn't move
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
    }
    
    // method for infinite scrolling BG
    func moveBackground() {
        
        // define the background texture
        var backgroundTexture = SKTexture(imageNamed: "bg.png")
        
        // move the bg from right to left
        var shiftBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        var replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        var movingAndReplacingBackground = SKAction.repeatActionForever(SKAction.sequence([shiftBackground, replaceBackground]))
        
        for var i:CGFloat = 0; i<3; i++ {
            // define bg, give it a height and moving width
            var background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + (backgroundTexture.size().width * i), y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.runAction(movingAndReplacingBackground)
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
