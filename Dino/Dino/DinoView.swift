//
//  DinoView.swift
//  Dino
//
//  Created by Yuhui Li on 2016-11-22.
//  Copyright © 2016 Yuhui Li. All rights reserved.
//

import Cocoa
import SpriteKit

class DinoView: SKView {
    
    let dinoScene = DinoScene(size: CGSize(width: 1005, height: 30))
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    func initScene() {
        self.presentScene(dinoScene)
    }
    
}
