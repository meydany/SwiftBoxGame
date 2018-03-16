//
//  Brickbox.swift
//  BoxGame
//
//  Created by Admin on 7/30/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BrickBox: SKShapeNode, BoxProtocol{
    
    var breakable = false
    
    override init() {
        super.init()
    }
    
    convenience init(breakable: Bool) {
        self.init()
        self.init(rectOf:  CGSize(width: (viewWidth)/10, height: (viewWidth)/10), cornerRadius: 4)
        self.isUserInteractionEnabled = true
        self.fillColor  = UIColor.gray
        
        self.breakable = breakable
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (viewWidth)/10, height: (viewWidth)/10))
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = ColliderObject.box.rawValue
        self.physicsBody?.contactTestBitMask = ColliderObject.bullet.rawValue
        self.physicsBody?.collisionBitMask = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nut()
    }
    
    //splurge
    func nut(){
        
    }
    
    func nut(bullet: BulletProtocol){
        bullet.nut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
