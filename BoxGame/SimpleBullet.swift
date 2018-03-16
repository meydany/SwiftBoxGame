//
//  SimpleBullet.swift
//  BoxGame
//
//  Created by Admin on 7/30/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit



class SimpleBullet: SKShapeNode, BulletProtocol{
    
    let radius:CGFloat = 3
    let SPEED:CGFloat = 150
    
    override init() {
        super.init()
    }
    
    convenience init(direction: Int, position: CGPoint) {
        self.init()
        self.init(circleOfRadius: radius)
        self.position = position
        self.fillColor = UIColor.black
        self.strokeColor = UIColor.black
        
        var move:SKAction?
        var finalPosition: CGPoint?
        
        switch (direction){
        case 0:
            finalPosition = CGPoint(x:viewWidth + radius + 1,y: self.position.y)
        case 1:
            finalPosition = CGPoint(x:self.position.x,y: 0 - radius - 1)
        case 2:
            finalPosition = CGPoint(x:0 - radius - 1,y: self.position.y)
        case 3:
            finalPosition = CGPoint(x:self.position.x,y: viewHeight + radius + 1)
        default:
            break
        }
        
        let deltaPos = sqrt(pow(finalPosition!.x - position.x, 2) + pow(finalPosition!.y - position.y, 2))
        let time = deltaPos/SPEED
        move = SKAction.move(to: finalPosition!, duration: Double(time))
        self.run(move!)
        
        let removeSelf = SKAction.sequence([SKAction.wait(forDuration: Double(time)), SKAction.run(self.removeFromParent)])
        self.run(removeSelf)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderObject.bullet.rawValue
        self.physicsBody?.contactTestBitMask = ColliderObject.box.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func nut(){
        self.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
