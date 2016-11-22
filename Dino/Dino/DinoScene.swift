//
//  DinoScene.swift
//  Dino
//
//  Created by Yuhui Li on 2016-11-22.
//  Copyright © 2016 Yuhui Li. All rights reserved.
//

import Cocoa
import SpriteKit

class DinoScene: SKScene {
    
    var sceneCreated = false
    
    let dinoDarkColor = SKColor(red: 83/255.0, green: 83/255.0, blue: 83/255.0, alpha: 1)
    
    override func didMove(to view: SKView) {
        print("c")
        
        if !sceneCreated {
            sceneCreated = true
            createSceneContents()
        }
    }
    
    func createSceneContents() {
        self.addChild(titleLabel())
        self.backgroundColor = SKColor.lightGray
        //self.scaleMode = .aspectFit
    }
    
    func titleLabel() -> SKLabelNode {
        let titleNode = SKLabelNode(fontNamed: "Courier")
        titleNode.text = "TouchBarDino"
        titleNode.fontSize = 13
        titleNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 4)
        titleNode.fontColor = dinoDarkColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            NSLog("%f",titleNode.frame.origin.x)
            NSLog("%f",titleNode.frame.origin.y)
            NSLog("%f",titleNode.frame.size.width)
            NSLog("%f",titleNode.frame.size.height)
            NSLog("%f",self.frame.size.width)
            NSLog("%f",self.frame.size.height)
        })
        
        return titleNode
    }
}
