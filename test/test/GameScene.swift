//
//  GameScene.swift
//  test
//
//  Created by Devon Law on 2019-06-10.
//  Copyright © 2019 Devon Law. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    struct Plank {
        var block = SKSpriteNode()
        let value: Int
    }
    var plank1 = Plank(block: SKSpriteNode(), value: 0) //top block
    var plank2 = Plank(block: SKSpriteNode(), value: 1) //middle block
    var plank3 = Plank(block: SKSpriteNode(), value: 2) //bottom block
    var plank4 = Plank(block: SKSpriteNode(), value: 3)
    var plank5 = Plank(block: SKSpriteNode(), value: 4)
    var base = SKSpriteNode()
    var stackLeft: [Plank] = []
    var stackMiddle: [Plank] = []
    var stackRight: [Plank] = []
    var topBlock = Plank(block: SKSpriteNode(), value: 4)
    var numMoves = SKLabelNode()
    var intMoves = 0
    var canMove = false //only true if the users move is valid
    //TODO: Add auto layout so the app fits all screen sizes
    var FIRST_LINE = CGFloat(0.0)
    var SECOND_LINE = CGFloat(0.0)
    var snapLocX = CGFloat(0.0)
    var snapLocY = CGFloat(0.0)
    var autoPosLeft = CGFloat(0.0)

    override func didMove(to view: SKView) {
        plank1.block = self.childNode(withName: "block5") as! SKSpriteNode //top block
        plank2.block = self.childNode(withName: "block4") as! SKSpriteNode
        plank3.block = self.childNode(withName: "block3") as! SKSpriteNode
        plank4.block = self.childNode(withName: "block2") as! SKSpriteNode
        plank5.block = self.childNode(withName: "block1") as! SKSpriteNode //bottom block
        base = self.childNode(withName: "base") as! SKSpriteNode
        numMoves = self.childNode(withName: "moves") as! SKLabelNode
        stackLeft.append(plank5)
        stackLeft.append(plank4)
        stackLeft.append(plank3)
        stackLeft.append(plank2)
        stackLeft.append(plank1) //initialize the stack at start of game
        for block in stackLeft {
            block.block.position.x = (frame.width / 3) * (-1)
        }
        autoPosLeft = plank5.block.position.x
        FIRST_LINE = frame.width/6 * -1
        SECOND_LINE = -FIRST_LINE
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !endGame() {
            for touch in touches {
                let location = touch.location(in: self)
                findSnapLocX(tap: location.x)
                if canMove {
                    if validateMove() {
                        topBlock.block.run(SKAction.moveTo(x: snapLocX, duration: 0.2))
                        findStackRemoveLast(topLayer: topBlock)
                        findSnapLocY()
                        findStackAddTop(topLayer: topBlock)
                        topBlock.block.run(SKAction.moveTo(y: snapLocY, duration: 0.2))
                        intMoves += 1
                    }
                    topBlock.block.color = .lightGray
                    canMove = false
                } else {
                    topBlock = findTopofStack(tap: snapLocX)                }
            }
        }
    }
    
    func findTopofStack(tap: CGFloat) -> Plank {
        if tap < FIRST_LINE && !stackLeft.isEmpty {
            canMove = true
            stackLeft.last!.block.color = .yellow
            return stackLeft.last!
        } else if tap >= FIRST_LINE && tap < SECOND_LINE && !stackMiddle.isEmpty {
            canMove = true
            stackMiddle.last!.block.color = .yellow
            return stackMiddle.last!
        } else if tap >= SECOND_LINE && !stackRight.isEmpty {
            canMove = true
            stackRight.last!.block.color = .yellow
            return stackRight.last!
        } else {
            return topBlock
        }
    }
    
    func findStackRemoveLast(topLayer: Plank) {
        for layer in stackLeft {
            if layer.value == topLayer.value {
                stackLeft.removeLast(1)
                return
            }
        }
        
        for layer in stackMiddle {
            if layer.value == topLayer.value {
                stackMiddle.removeLast(1)
                return
            }
        }
        
        for layer in stackRight {
            if layer.value == topLayer.value {
                stackRight.removeLast(1)
                return
            }
        }
        
    }
    
    func findStackAddTop(topLayer: Plank) {
        if snapLocX == autoPosLeft {
            stackLeft.append(topLayer)
        } else if snapLocX == 0 {
            stackMiddle.append(topLayer)
        } else {
            stackRight.append(topLayer)
        }
    }
    
    func findStack() -> Array<Plank> {
        if snapLocX == autoPosLeft {
            return stackLeft
        } else if snapLocX == 0 {
            return stackMiddle
        } else {
            return stackRight
        }
    }
    
    func validateMove() -> Bool {
        if findStack().last == nil {
            return true
        } else if topBlock.value < findStack().last!.value {
            return true
        } else {
            return false
        }
    }
    
    func endGame() -> Bool {
        if stackRight.count == 5 {
            stackRight[0].block.color = .red
            stackRight[1].block.color = .green
            stackRight[2].block.color = .blue
            stackRight[3].block.color = .purple
            stackRight[4].block.color = .cyan
            return true
        } else {
            return false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !endGame(){
            numMoves.text = String(intMoves)
        } else {
            numMoves.text = "Completed in " + String(intMoves) + "!"
        }
    }

    func findSnapLocX(tap: CGFloat) {
        if tap <= FIRST_LINE {
            snapLocX = autoPosLeft
        } else if tap > FIRST_LINE && tap <= SECOND_LINE {
            snapLocX = 0
        } else {
            snapLocX = -autoPosLeft
        }
    }
    
    func findSnapLocY() {
        if findStack().count == 0 {
            snapLocY = -455.001
        } else if findStack().count == 1 {
            snapLocY = -405.001
        } else if findStack().count == 2 {
            snapLocY = -355.001
        } else if findStack().count == 3 {
            snapLocY = -305.001
        } else {
            snapLocY = -255.001
        }
    }
}
