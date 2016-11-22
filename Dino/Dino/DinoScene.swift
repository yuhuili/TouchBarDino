//
//  DinoScene.swift
//  Dino
//
//  Created by Yuhui Li on 2016-11-22.
//  Copyright © 2016 Yuhui Li. All rights reserved.
//

import Cocoa
import SpriteKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Edge: UInt32 = 0b1
    static let Character: UInt32 = 0b10
    static let Collider: UInt32 = 0b100
    static let Obstacle: UInt32 = 0b100
}

class DinoScene: SKScene, SKPhysicsContactDelegate {
    
    var sceneCreated = false
    var canJump = false // only allow jumping when hit ground
    var continueSpawnObstacle = true
    
    let dinoDarkColor = SKColor(red: 83/255.0, green: 83/255.0, blue: 83/255.0, alpha: 1)
    let dinoSpriteNode = SKSpriteNode(imageNamed: "DinoSprite")
    let bottomCollider: SKPhysicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y:0), to: CGPoint(x:1005, y:0))
    
    override func didMove(to view: SKView) {
        print("c")
        
        if !sceneCreated {
            sceneCreated = true
            createSceneContents()
        }
    }
    
    func logger() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            NSLog("Sprite at: %f, %f", self.dinoSpriteNode.position.x, self.dinoSpriteNode.position.y)
            self.logger()
        })
    }
    
    func jump() {
        print("a")
        if !canJump {
            return
        }
        print("b")
        //dinoSpriteNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy:10), at: dinoSpriteNode.position)
        if let pb = dinoSpriteNode.physicsBody {
            print("c")
            pb.applyImpulse(CGVector(dx:0, dy:8.8), at: dinoSpriteNode.position)
        }
    }
    
    func spawnObstacle() {
        let x = arc4random() % 2;
        
        if x==0 {
            // Create
            let ob = SKSpriteNode(imageNamed: "Obstacle")
            ob.position = CGPoint(x: 900, y: 12)
            ob.setScale(0.38)
            ob.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Obstacle"), size: ob.size)
            if let pb = ob.physicsBody {
                pb.isDynamic = true
                pb.affectedByGravity = false
                pb.allowsRotation = false
                pb.categoryBitMask = PhysicsCategory.Obstacle
                pb.contactTestBitMask = PhysicsCategory.Character
                pb.collisionBitMask = 0
                pb.restitution = 0
                pb.friction = 0
                pb.linearDamping = 0
                pb.angularDamping = 0
                pb.velocity = CGVector(dx: -140, dy: 0)
            }
            self.addChild(ob)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 12.0, execute: {
                if self.continueSpawnObstacle {
                    self.removeChildren(in: [ob])
                }
            })
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.continueSpawnObstacle {
                self.spawnObstacle()
            }
        })
    }
    
    func createSceneContents() {
        self.addChild(titleLabel())
        self.addChild(dinoSprite())
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.lightGray
        //self.scaleMode = .aspectFit
        
        self.physicsBody = bottomCollider
        bottomCollider.categoryBitMask = PhysicsCategory.Edge | PhysicsCategory.Collider
        bottomCollider.contactTestBitMask = PhysicsCategory.Character
        bottomCollider.friction = 0
        bottomCollider.restitution = 0
        bottomCollider.linearDamping = 0
        bottomCollider.angularDamping = 1
        bottomCollider.isDynamic = false
        bottomCollider.affectedByGravity = false
        bottomCollider.allowsRotation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        //self.logger()
        self.spawnObstacle()
    }
    
    func titleLabel() -> SKLabelNode {
        let titleNode = SKLabelNode(fontNamed: "Courier")
        titleNode.text = "TouchBarDino"
        titleNode.fontSize = 13
        titleNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 4)
        titleNode.fontColor = dinoDarkColor
        
        
        
        return titleNode
    }
    
    func dinoSprite() -> SKSpriteNode {
        dinoSpriteNode.setScale(0.5)
        dinoSpriteNode.position = CGPoint(x: 20, y: 40)
        dinoSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: dinoSpriteNode.size)
        if let pb = dinoSpriteNode.physicsBody {
            pb.isDynamic = true
            pb.affectedByGravity = true
            pb.allowsRotation = false
            pb.categoryBitMask = PhysicsCategory.Character
            pb.collisionBitMask = PhysicsCategory.Edge
            pb.contactTestBitMask = PhysicsCategory.Collider
            pb.restitution = 0
            pb.friction = 1
            pb.linearDamping = 1
            pb.angularDamping = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            //NSLog("%f",self.dinoSpriteNode.frame.origin.y)

        })
        return dinoSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("begin")
        if (contact.bodyA == dinoSpriteNode.physicsBody && contact.bodyB == bottomCollider) ||
            (contact.bodyB == dinoSpriteNode.physicsBody && contact.bodyA == bottomCollider) {
            canJump = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("end")
        if (contact.bodyA == dinoSpriteNode.physicsBody && contact.bodyB == bottomCollider) ||
            (contact.bodyB == dinoSpriteNode.physicsBody && contact.bodyA == bottomCollider) {
            canJump = false
        } else {
            // Must have hit an obstacle
            print("HIT")
            canJump = false
            continueSpawnObstacle = false
            for node in self.children {
                if (node.physicsBody?.categoryBitMask == PhysicsCategory.Obstacle) {
                    node.physicsBody?.velocity = CGVector(dx:0, dy:0)
                }
            }
        }
    }
    
    
}
