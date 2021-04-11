//  Connect4Constants.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation
import UIKit

struct ColorConstants {
    static let boardColor: UIColor = UIColor(red: 0.13, green: 0.45, blue: 0.44, alpha: 1)
    static let boardBorderColor: UIColor = UIColor(red: 0.08, green: 0.2, blue: 0.21, alpha: 1)
    static let redOuterDisc: UIColor = UIColor(red: 0.65, green: 0.07, blue: 0.15, alpha: 1)
    static let redInnerDisc: UIColor = UIColor(red: 0.8, green: 0.17, blue: 0.25, alpha: 1)
    static let yellowOuterDisc: UIColor = UIColor(red: 0.83, green: 0.69, blue: 0.12, alpha: 1)
    static let yellowInnerDisc: UIColor = UIColor(red: 0.99, green: 0.80, blue: 0.04, alpha: 1)
}

struct BoardConstants {
    static let rows: Int = 6
    static let columns: Int = 7
    static let sleepTime: Double = 0.1
    static let wedgeRatio: CGFloat = 0.2
    static let widthRatio: CGFloat = 0.97
    static let outerDiscRatio: CGFloat = 0.4
    static let innerDiscRatio: CGFloat = 0.85
    static let boardCornerRatio: CGFloat = 0.1
}

struct BoardIdentifiers {
    static let wedge: String = "wedge"
    static let barrier: String = "barrier"
}
