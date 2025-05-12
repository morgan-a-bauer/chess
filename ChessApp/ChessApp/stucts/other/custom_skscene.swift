//
//  custom_skscene.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/19/25.
//
import SpriteKit

class CustomSKScene: SKScene {
    var nodeMap = NodeMap<String, SKNode>()
    
    override var children: [SKNode] {
        return nodeMap.values
    }
    
    override func addChild(_ node: SKNode) {
        guard let name = node.name else{
            fatalError("Nodes muust have a unique name.")
        }
        if node.zPosition == 1 {
            nodeMap[name] = node
        }
        super.addChild(node)
    }
    
    override func removeChildren(in nodes: [SKNode]) {
        for node in nodes {
            if let name = node.name {
                nodeMap.removeValue(forKey: name)
            }
        }
        super.removeChildren(in: nodes)
    }
    
    // Use this for checking node locations...
    // Hmmmmm. This is the actual square cells themselves. Some more is needed to check for if a piece is present...
    func getNode(named name: Int) -> SKNode? {
        return nodeMap[String(name)]
    }
}
