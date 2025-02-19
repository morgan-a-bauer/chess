//
//  children_override.swift
//  ChessApp
//
//  Created by Jackson Butler on 2/17/25.
//

import SpriteKit


struct NodeMap<Key: Hashable, Value: SKNode> {
    private var storage: [Key: SKNode] = [:]

    // Subscript for indexing like a dictionary
    subscript(key: Key) -> SKNode? {
        get { return storage[key] }
        set { storage[key] = newValue }
    }

    // Check if a key exists
    func contains(_ key: Key) -> Bool {
        return storage[key] != nil
    }

    // Get all keys
    var keys: [Key] {
        return Array(storage.keys)
    }

    // Get all values
    var values: [SKNode] {
        return Array(storage.values)
    }

    // Remove key-value pair
    mutating func removeValue(forKey key: Key) {
        storage.removeValue(forKey: key)
    }

    // Clear all values
    // Really just to maintain full functionality
    mutating func clear() {
        storage.removeAll()
    }
    
    // HashMap key change on piece move
    mutating func move(piece node: SKNode, to: Int) {
        // Maybe extend node's functionality to inherit a piece type/ have piece types which inherit from SKNode
        
        self[node.name as! Key] = nil
        self[String(to) as! Key] = node
    }
}
