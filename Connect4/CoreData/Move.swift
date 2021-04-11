////  Move.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/22.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation

public class Move: NSObject, NSCoding {
    public var index: Int = 0
    public var action: Int = 0
    public var color: Int = 1
    
    enum Key:String {
        case index = "index"
        case action = "action"
        case color = "color"
    }
    
    init(index: Int, action: Int, color: Int) {
        self.index = index
        self.action = action
        self.color = color
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(index, forKey: Key.index.rawValue)
        coder.encode(action, forKey: Key.action.rawValue)
        coder.encode(color, forKey: Key.color.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mIndex = coder.decodeInt32(forKey: Key.index.rawValue)
        let mAction = coder.decodeInt32(forKey: Key.action.rawValue)
        let mColor = coder.decodeInt32(forKey: Key.color.rawValue)
        
        self.init(index: Int(mIndex), action: Int(mAction), color: Int(mColor))
    }
    

}
