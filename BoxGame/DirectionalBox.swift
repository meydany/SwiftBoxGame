//
//  DirectionalBox.swift
//  BoxGame
//
//  Created by Admin on 7/30/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum Direction{
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

class DirectionalBox: SKShapeNode, BoxProtocol{
    
    var direction: Direction?
    
    override init() {
        super.init()
    }
    
    convenience init(direction: Direction) {
        self.init()
        self.init(rectOf:  CGSize(width: (viewWidth)/10, height: (viewWidth)/10), cornerRadius: 4)
        
        self.direction = direction
        
        self.isUserInteractionEnabled = true
        self.fillColor = UIColor.gray
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (viewWidth)/10, height: (viewWidth)/10))
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = ColliderObject.box.rawValue
        self.physicsBody?.contactTestBitMask = ColliderObject.bullet.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //nut()
    }
    
    //splurge
    func nut(){
        self.removeFromParent()
    }
    
    func nut(bullet: BulletProtocol) {
        switch(direction!){
        case .UP:
            if ((bullet as! SKShapeNode).position.y >= self.position.y){
                bullet.nut()
            }
            break
        case .DOWN:
            if ((bullet as! SKShapeNode).position.y <= self.position.y){
                bullet.nut()
            }
            break
        case .RIGHT:
            if ((bullet as! SKShapeNode).position.x >= self.position.x){
                bullet.nut()
            }
            break
        case .LEFT:
            if ((bullet as! SKShapeNode).position.x <= self.position.x){
                bullet.nut()
            }
            break
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

