//
//  Background.swift
//  Flappy
//
//  Created by bitmaker on 2015-05-22.
//  Copyright (c) 2015 chad. All rights reserved.
//

import SpriteKit
import Foundation

class Background : SKScene {

    // Background layer 1
    func addBackground1(background:SKTexture, velocity:Double, zindex:CGFloat, view:SKScene) {
        
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
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + (backgroundTexture.size().width * i), y: backgroundTexture.size().height)
            background.size.width = background.size.width * 2
            background.size.height = background.size.height * 2
            background.runAction(movingAndReplacingBackground)
            background.zPosition = zindex
            view.addChild(background)
        }
    }
    
    // Background layer 2
    func addBackground2(background:SKTexture, velocity:Double, zindex:CGFloat, view:SKScene) {
        
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
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + (backgroundTexture.size().width * i), y: backgroundTexture.size().height)
            background.size.width = background.size.width * 2
            background.size.height = background.size.height * 2
            background.runAction(movingAndReplacingBackground)
            background.zPosition = zindex
            view.addChild(background)
        }
    }


}