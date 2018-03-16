//
//  GameScene.swift
//  BoxGame
//
//  Created by Yoli Meydan on 7/29/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BlockType {
    case BLACK
    case WHITE
    
    case DIRECTIONAL_UP
    case DIRECTIONAL_RIGHT
    case DIRECTIONAL_LEFT
    case DIRECTIONAL_DOWN
    
    case BRICK
}

let viewWidth = UIScreen.main.bounds.width
let viewHeight = UIScreen.main.bounds.height

enum ColliderObject: UInt32 {
    case box = 1
    case bullet = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    

    var lossCheck: SKAction!
    
    override func didMove(to view: SKView) {

        loadNextLevel()
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        // DO NOT READ AT ALL COSTS THIS WILL BE REPLACED
        // IM NOT KIDDING THIS IS NOT A DRILL DO NOT READ THE NEXT LINE
        
        lossCheck = SKAction.repeatForever(SKAction.sequence([SKAction.run(checkIfTheyLost), SKAction.wait(forDuration: 0.5)]))
        self.run(lossCheck, withKey: "lossCheck")
    }
 
    
    func getBlockType(raw: String) -> BlockType {
        switch(raw) {
            case "0": return BlockType.WHITE
            case "1": return BlockType.BLACK
            
            case "2": return BlockType.DIRECTIONAL_RIGHT
            case "3": return BlockType.DIRECTIONAL_DOWN
            case "4": return BlockType.DIRECTIONAL_LEFT
            case "5": return BlockType.DIRECTIONAL_UP
            
            case "6": return BlockType.BRICK
            
            default: return BlockType.BLACK
        }
    }
    
    func setupMap() {
        let map = LevelManager.currentMap
        print("run")
        if (map.isEmpty){
            print("empty map")
            return
        }
        
        for rowIndex in 0...map.count-1 {
            for colIndex in 0...map[rowIndex].count-1 {
                let blockType = getBlockType(raw: map[rowIndex][colIndex])
                
                if (blockType == .WHITE){
                    continue
                }
                
                var boxNode:SKShapeNode?
                
                switch (blockType){
                case .BLACK:
                    boxNode = SimpleBox(rectOf: CGSize(width: 0, height: 0))
                    break
                case .BRICK:
                    boxNode = BrickBox(breakable: false)
                    break
                case .DIRECTIONAL_UP:
                    boxNode = DirectionalBox(direction: Direction.UP)
                    break
                case .DIRECTIONAL_LEFT:
                    boxNode = DirectionalBox(direction: Direction.LEFT)
                    break
                case .DIRECTIONAL_DOWN:
                    boxNode = DirectionalBox(direction: Direction.DOWN)
                    break
                case .DIRECTIONAL_RIGHT:
                    boxNode = DirectionalBox(direction: Direction.RIGHT)
                    break
                default:
                    break
                }
                
                //this positioning is sus af and is not optimized by any means
                let xPosition = (viewWidth/MAP_WIDTH) * CGFloat(colIndex + 1) - (viewWidth/20)
                let yPosition = viewHeight - ((viewHeight/MAP_HEIGHT) * CGFloat(rowIndex + 1) - (viewWidth/20))
                
                boxNode!.position = CGPoint(x: xPosition, y: yPosition)
                
                self.addChild(boxNode!)

            }
        }
    }
    
    func bulletHitBox(bullet: BulletProtocol, box: BoxProtocol) {
        box.nut(bullet: bullet)
        checkIfTheyWon()
    }
    
    func checkIfTheyLost(){
        print("runit")
        for node in self.children{
            if (node is BulletProtocol){
                return
            }
        }
        
        var isThereABoxLeft = false
        
        for node in self.children{
            print("loop")
            if (node is BoxProtocol){
                isThereABoxLeft = true
                break
            }
        }
        
        if (LevelManager.allowedClicksForThisLevel <= 0 && isThereABoxLeft){
            self.removeAction(forKey: "lossCheck")
            playerLost()
        }
    }
    
    func checkIfTheyWon(){
        for node in self.children{
            if (node is SimpleBox){
                return
            }
        }
        
        for node in self.children{
            if (node is BoxProtocol || node is BulletProtocol){
                node.physicsBody = nil
                let fadeAway = SKAction.fadeOut(withDuration: 1.0)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            }
        }
        
        loadNextLevel()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & ColliderObject.box.rawValue != 0) &&
            (secondBody.categoryBitMask & ColliderObject.bullet.rawValue != 0)) {
            
            let box = firstBody.node as? BoxProtocol
            let bullet = secondBody.node as? BulletProtocol
            bulletHitBox(
                bullet: bullet!,
                box: box!
            )
            
        }
        
    }
    
    func playerLost(){
        print("sry boy u lost")
    }
    
    //temp
    func loadNextLevel(){
        LevelManager.loadNextLevel()
        setupMap()
        print("u got ", LevelManager.allowedClicksForThisLevel," clicks")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
