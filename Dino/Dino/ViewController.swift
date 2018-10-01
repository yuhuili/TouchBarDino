//
//  ViewController.swift
//  Dino
//
//  Created by Yuhui Li on 2016-11-21.
//  Copyright © 2016 Yuhui Li. All rights reserved.
//

import Cocoa
import SpriteKit

struct Constants {
    static let touchBarWidth:CGFloat = 1005.0
    static let backgroundColor = NSColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
}

class ViewController: NSViewController {
    
    let dinoView: NSView = NSView()
    let dinoSKView = DinoView()
    let mainTapReceiverButton = NSButton(title: " ", target: self, action: #selector(tap))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDinoView()
        setupMainTapReceiverButton()
    }
    
    func tap() {
        dinoSKView.dinoScene.jump()
    }
    
    func setupDinoView() {
        
        // Fix width
        dinoSKView.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: dinoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Constants.touchBarWidth)
        // Constraints to sides
        let c2 = NSLayoutConstraint(item: dinoSKView, attribute: .leading, relatedBy: .equal, toItem: dinoView, attribute: .leading, multiplier: 1.0, constant: 0)
        let c3 = NSLayoutConstraint(item: dinoSKView, attribute: .trailing, relatedBy: .equal, toItem: dinoView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let c4 = NSLayoutConstraint(item: dinoSKView, attribute: .top, relatedBy: .equal, toItem: dinoView, attribute: .top, multiplier: 1.0, constant: 0)
        let c5 = NSLayoutConstraint(item: dinoSKView, attribute: .bottom, relatedBy: .equal, toItem: dinoView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        dinoView.addConstraints([c1, c2, c3, c4, c5])
        
        dinoView.wantsLayer = true
        dinoView.layer?.backgroundColor = Constants.backgroundColor.cgColor

        dinoSKView.initScene()
        
        dinoView.addSubview(dinoSKView)
        dinoView.addSubview(mainTapReceiverButton)
    }
    
    func setupDinoViewOnAppear() {
        
        if let touchBarView = dinoView.superview {
            
            // Constraints to sides
            let c1 = NSLayoutConstraint(item: dinoView, attribute: .leading, relatedBy: .equal, toItem: touchBarView, attribute: .leading, multiplier: 1.0, constant: 0)
            let c2 = NSLayoutConstraint(item: dinoView, attribute: .trailing, relatedBy: .equal, toItem: touchBarView, attribute: .trailing, multiplier: 1.0, constant: 0)
            let c3 = NSLayoutConstraint(item: dinoView, attribute: .top, relatedBy: .equal, toItem: touchBarView, attribute: .top, multiplier: 1.0, constant: 0)
            let c4 = NSLayoutConstraint(item: dinoView, attribute: .bottom, relatedBy: .equal, toItem: touchBarView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            touchBarView.addConstraints([c1, c2, c3, c4])
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.setupDinoView()
            })
        }
    }
    
    func setupMainTapReceiverButton() {
        mainTapReceiverButton.isTransparent = true
        mainTapReceiverButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints to sides
        let c1 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .leading, relatedBy: .equal, toItem: dinoView, attribute: .leading, multiplier: 1.0, constant: 0)
        let c2 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .trailing, relatedBy: .equal, toItem: dinoView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let c3 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .top, relatedBy: .equal, toItem: dinoView, attribute: .top, multiplier: 1.0, constant: 0)
        let c4 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .bottom, relatedBy: .equal, toItem: dinoView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        dinoView.addConstraints([c1, c2, c3, c4])
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

@available(OSX 10.12.2, *)
extension ViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .dinoBar
        touchBar.defaultItemIdentifiers = [.dinoItem]
        touchBar.customizationAllowedItemIdentifiers = [.dinoItem]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.dinoItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = dinoView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                // Setup dinoView Constraints on TouchBar View Load
                self.setupDinoView()
            })
            return customViewItem
        default:
            return nil
        }
    }
}

extension NSTouchBarCustomizationIdentifier {
    static let dinoBar = NSTouchBarCustomizationIdentifier("com.yuhuili.Dino.DinoBar")
}

extension NSTouchBarItemIdentifier {
    static let dinoItem = NSTouchBarItemIdentifier("com.yuhuili.Dino.DinoBar.main")
}



