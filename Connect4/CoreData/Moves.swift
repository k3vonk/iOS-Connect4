////  Moves.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/22.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation

public class Moves: NSObject, NSCoding {

    public var moves: [Move] = []
    
    enum Key: String {
        case moves = "moves"
    }
    
    init(moves: [Move]) {
        self.moves = moves
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(moves, forKey: Key.moves.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mMoves = coder.decodeObject(forKey: Key.moves.rawValue) as! [Move]
        self.init(moves: mMoves)
    }
    
}
