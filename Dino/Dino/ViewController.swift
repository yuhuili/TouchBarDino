//
//  ViewController.swift
//  Dino
//
//  Created by Yuhui Li on 2016-11-21.
//  Copyright © 2016 Yuhui Li. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let dinoView: DinoView = DinoView()
    let simpleTextField: NSTextField = NSTextField(labelWithString: "JAY IS SMART")
    let overlayButton = NSButton(title: " ", target: self, action: #selector(jump))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dinoView.wantsLayer = true
        self.dinoView.layer?.backgroundColor = NSColor(red: 0.3, green: 0.3, blue: 0.85, alpha: 1).cgColor
        self.dinoView.addSubview(simpleTextField)
        self.dinoView.addSubview(overlayButton)
        
        self.overlayButton.frame = NSRect(x: 0, y: 0, width: 1005, height: 30)
        self.overlayButton.isTransparent = true
        
    }
    
    func jump() {
        print("TAPPED")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension NSTouchBarCustomizationIdentifier {
    static let dinoBar = NSTouchBarCustomizationIdentifier("com.yuhuili.Dino.DinoBar")
}

extension NSTouchBarItemIdentifier {
    static let dinoItem = NSTouchBarItemIdentifier("com.yuhuili.Dino.DinoBar.main")
}

@available(OSX 10.12.1, *)
extension ViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        // 1
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        // 2
        touchBar.customizationIdentifier = .dinoBar
        // 3
        touchBar.defaultItemIdentifiers = [.dinoItem]
        // 4
        touchBar.customizationAllowedItemIdentifiers = [.dinoItem]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.dinoItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = dinoView
            return customViewItem
        default:
            return nil
        }
    }
}




