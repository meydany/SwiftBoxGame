//
//  SimpleBox.swift
//  BoxGame
//
//  Created by Admin on 7/30/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class SimpleBox: SKShapeNode, BoxProtocol{
    
    override init() {
        super.init()
    }
    
    convenience init(rectOf: CGSize) {
        self.init()
        self.init(rectOf:  CGSize(width: (viewWidth)/10, height: (viewWidth)/10), cornerRadius: 4)
        self.isUserInteractionEnabled = true
        self.fillColor = UIColor.black
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (viewWidth)/10, height: (viewWidth)/10))
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = ColliderObject.box.rawValue
        self.physicsBody?.contactTestBitMask = ColliderObject.bullet.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (LevelManager.allowedClicksForThisLevel <= 0){return}
        
        LevelManager.allowedClicksForThisLevel = LevelManager.allowedClicksForThisLevel - 1
        nut()
    }
    
    //splurge
    func nut(){
        for i in 0...3{
            self.parent?.addChild(SimpleBullet(direction: i, position: self.position))
        }
        self.removeFromParent()
    }
    
    func nut(bullet: BulletProtocol){
        bullet.nut()
        self.nut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
