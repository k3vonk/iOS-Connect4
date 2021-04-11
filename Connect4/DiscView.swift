//  DiscView.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/18.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit
import Alpha0Connect4 // required for 'Color'


class DiscView: UIView {
    
    private var move: (action: Int, color: Color, index: Int)
    private var label: UILabel
    private var strokeText = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : 4.0
    ] as [NSAttributedString.Key : Any]
    
    init(frame: CGRect, move: (action: Int, color: Color, index: Int)?) {
        self.move = move ?? (action: 1, color: Color.yellow, index: 1)

        label = UILabel(frame: frame)
        label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        label.textAlignment = .center
        super.init(frame: frame)
        
        // Create the layer for displaying the disc
        if self.move.color == Color.red {
            backgroundColor = ColorConstants.redInnerDisc
            layer.borderColor = ColorConstants.redOuterDisc.cgColor
        } else {
            backgroundColor = ColorConstants.yellowInnerDisc
            layer.borderColor = ColorConstants.yellowOuterDisc.cgColor
        }
        
        layer.cornerRadius = (frame.size.width / 2.0)
        layer.borderWidth = layer.cornerRadius * BoardConstants.outerDiscRatio
        
        strokeText[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: frame.size.width * CGFloat(0.4))
    }
    
    func displayLabel(_ indicies: [Int]?) {
        if (indicies?.contains(move.action) ?? false) { // Configure text style based on action
            strokeText = [
                NSAttributedString.Key.strokeColor : UIColor.white,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeWidth : -4.0
            ]
        }
        
        label.attributedText = NSMutableAttributedString(string: "\(move.index)", attributes: strokeText)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }

}
