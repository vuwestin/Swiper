//
//  GameScene.swift
//  Swiper
//
//  Created by Westin Vu on 7/21/19.
//  Copyright © 2019 LearnAppMaking. All rights reserved.
//

import SpriteKit

enum arrowDirectionTypes
{
    static let Up = 0.0
    static let Left = Double.pi/2
    static let Down = Double.pi
    static let Right = Double.pi * 1.5
}

enum ZPositions
{
    static let arrow: CGFloat = 1
    static let label: CGFloat = 2
}

class GameScene: SKScene {

    var backgroundColors = [
    UIColor.red,
    UIColor.green,
    UIColor.blue,
    UIColor.orange,
    UIColor.purple,
    UIColor.yellow
    ]
    
    var rotationCase: CGFloat = 0.0
    let arrowDirections = [arrowDirectionTypes.Up, arrowDirectionTypes.Left, arrowDirectionTypes.Down, arrowDirectionTypes.Right]
    //up, left, down, right
    private var timerLabel = SKLabelNode(fontNamed: "ArialMT")
    var score = 0
    {
        didSet
        {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var scoreLabel = SKLabelNode(fontNamed: "ArialMT")
    var time = 15
    {
        didSet
        {
            timerLabel.text = "Time: \(time)"
        }
    }
    
    
    var currentBackgroundColor = UIColor.blue //random values for initializer
    var currentArrowColor: UIColor = UIColor.black


    private var arrow = SKSpriteNode(imageNamed: "whiteArrow")
    
    
    
    override func didMove(to view: SKView) {
        
        layoutScene()
        swipeSetup()
        newTurn()
        labelSetup()
        timerSetup()
    }
    
    func layoutScene()
    {
        //let arrow: SKSpriteNode = SKSpriteNode(imageNamed: "whiteArrow")
        arrow.size.width = 500
        arrow.size.height = 500
        arrow.position = CGPoint(x: frame.midX, y: frame.midY)
        arrow.colorBlendFactor = 1
        arrow.zPosition = ZPositions.arrow
        addChild(arrow)
    }
    
    func newTurn()
    {
        let randomBackgroundColor = backgroundColors.randomElement()
        let randColorIndex = backgroundColors.firstIndex(of: randomBackgroundColor!)
        backgroundColors.remove(at: randColorIndex!)
        let arrowColor = backgroundColors.randomElement()
        self.backgroundColor = randomBackgroundColor!
        currentBackgroundColor = self.backgroundColor
        arrow.color = arrowColor!
        currentArrowColor = arrow.color
        updateLabelColors()
        rotationCase = CGFloat(arrowDirections.randomElement()!)
        arrow.zRotation = rotationCase
        backgroundColors.append(randomBackgroundColor!)
    }
    
    func timerSetup()
    {
        let wait = SKAction.wait(forDuration: 1)
        let decrementTimer = SKAction.run
        {
            self.time -= 1
            if (self.time == 0)
            {
                self.gameOver()
            }
        }
        let sequence = SKAction.repeatForever(SKAction.sequence([wait,decrementTimer]))
        run(sequence)
    }
    
    func labelSetup(){
        scoreLabel.color = currentArrowColor
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/5)
        //scoreLabel.text = "Score: \(score)"
        scoreLabel.text = "Score: \(score)"
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        timerLabel.color = currentArrowColor
        timerLabel.fontSize = 40
        timerLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height * 0.8)
        timerLabel.text = "Time: \(time)"
        timerLabel.zPosition = ZPositions.label
        addChild(timerLabel)
    }

    func updateLabelColors()
    {
        scoreLabel.fontColor = currentArrowColor
        timerLabel.fontColor = currentArrowColor
//        print("test")
//        addChild(scoreLabel)
//        addChild(timerLabel)
    }
    func swipeSetup()
    {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                //UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
            gesture.direction = direction
            self.view?.addGestureRecognizer(gesture)
        }
    }
    
    func isComplementary() -> Bool
    {
        if((currentArrowColor == UIColor.blue && currentBackgroundColor == UIColor.orange) ||
            (currentArrowColor == UIColor.red && currentBackgroundColor == UIColor.green) ||
            (currentArrowColor == UIColor.purple && currentBackgroundColor == UIColor.yellow) ||
            (currentArrowColor == UIColor.orange && currentBackgroundColor == UIColor.blue) ||
            (currentArrowColor == UIColor.green && currentBackgroundColor == UIColor.red) ||
            (currentArrowColor == UIColor.yellow && currentBackgroundColor == UIColor.purple))
        {
            return true
        }
        return false
    }
    
    func gameOver()
    {
        if self.score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(self.score, forKey: "HighScore")
        }
        let menuScene = MenuScene(size: self.view!.bounds.size)
        self.view!.presentScene(menuScene)
    }
    
    func checkSwipe(compCase: Double, regCase :Double)
    {
        if(isComplementary())
        {
            if(rotationCase == CGFloat(compCase))
            {
                score += 1
                newTurn()
            }
            else
            {
                gameOver()
            }
        }
        else
        {
            if(rotationCase == CGFloat(regCase))
            {
                score += 1
                newTurn()
            }
            else
            {
                gameOver()
            }
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer)
    {
        switch sender.direction
        {
        case UISwipeGestureRecognizer.Direction.right:
            checkSwipe(compCase: arrowDirectionTypes.Left, regCase: arrowDirectionTypes.Right)
        case UISwipeGestureRecognizer.Direction.left:
            checkSwipe(compCase: arrowDirectionTypes.Right, regCase: arrowDirectionTypes.Left)
        case UISwipeGestureRecognizer.Direction.up:
            checkSwipe(compCase: arrowDirectionTypes.Down, regCase: arrowDirectionTypes.Up)
        case UISwipeGestureRecognizer.Direction.down:
            checkSwipe(compCase: arrowDirectionTypes.Up, regCase: arrowDirectionTypes.Down)
        default:
            print("error")
        }
    }
}
