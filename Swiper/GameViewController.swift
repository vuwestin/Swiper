//
//  GameViewController.swift
//  Swiper
//
//  Created by Westin Vu on 7/21/19.
//  Copyright © 2019 LearnAppMaking. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: view.bounds.size)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
        }
    }


//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
