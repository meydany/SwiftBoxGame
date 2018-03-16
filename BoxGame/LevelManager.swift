//
//  LevelManager.swift
//  BoxGame
//
//  Created by Yoli Meydan on 7/30/17.
//  Copyright © 2017 Yoli Meydan. All rights reserved.
//

import Foundation
import SpriteKit

var MAP_WIDTH: CGFloat = 0
var MAP_HEIGHT: CGFloat = 0

class LevelManager {

    static var currentMap: [[String]] = []
    static var currentLevel:Int = 0
    static var allowedClicksForThisLevel:Int!
    
    
    class func loadLevel(levelToLoad: Int) {
        currentMap.removeAll()
        if let path = Bundle.main.path(forResource: String(levelToLoad), ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                var mapRows = data.components(separatedBy: .newlines) as [String]

                allowedClicksForThisLevel = Int(mapRows[16])
                mapRows.remove(at: 16)
                
                for row in mapRows {
                    let singleSpace = row.components(separatedBy: .whitespaces) as [String]
                    currentMap.append(singleSpace)
                }
                
                MAP_HEIGHT = CGFloat(currentMap.count)
                MAP_WIDTH = CGFloat(currentMap[0].count)
                
                currentMap.remove(at: 16) //dont ask just go with it pls
                //print(currentMap)
            } catch {
                print(error)
            }
        }
    }

    class func loadNextLevel(){
        currentLevel = currentLevel + 1
        loadLevel(levelToLoad: currentLevel)
    }
    
}
