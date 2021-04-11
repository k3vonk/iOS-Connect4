//  DiscBehavior.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/18.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class DiscBehavior: UIDynamicBehavior {
    lazy var collider = UICollisionBehavior()
    
    lazy var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.action = { return self.outOfBounds?() }
        return gravity
    }()
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.resistance = 2
        behavior.elasticity = 1
        behavior.allowsRotation = false
        return behavior
    }()
    
    var outOfBounds: (() -> Void)? // Check if disc is out of bounds
    
    init(_ outOfBoundsFunc: (() -> Void)?) {
        outOfBounds = outOfBoundsFunc
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addBubble(_ bubble: UIView) {
        dynamicAnimator?.referenceView?.addSubview(bubble)
        dynamicAnimator?.referenceView?.sendSubviewToBack(bubble)
        gravity.addItem(bubble)
        collider.addItem(bubble)
        itemBehavior.addItem(bubble)
    }
    
    func removeBubble(_ bubble: UIView) {
        gravity.removeItem(bubble)
        collider.removeItem(bubble)
        itemBehavior.removeItem(bubble)
        bubble.removeFromSuperview()
    }
    
    func addBarrier(_ path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func removeBarrier(named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
    }
    
    func adjustBehaviorForReplay() {
        gravity.magnitude = 8
        itemBehavior.resistance = 0
        itemBehavior.elasticity = 0
    }

}
