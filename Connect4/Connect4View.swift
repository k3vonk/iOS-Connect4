//  Connect4View.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit


protocol Connect4DataSource: class {
    var startPoint: CGPoint { get }
    var innerDiscRadius: CGFloat { get }
    var gridWidth: CGFloat { get }
    func getPoint(_ column: Int,_ row: Int) -> CGPoint
}

class Connect4View: UIView {

    var boardWidth: CGFloat { return min(bounds.width, bounds.height) }
    var boardCenter: CGPoint { return convert(center, from: superview) }
    var boardColliders = [String: UIBezierPath]()
    private let board = CAShapeLayer()
    
    weak var boardSources: Connect4DataSource?
    

    override func draw(_ rect: CGRect) {
        board.removeFromSuperlayer()
        
        if let delegate = boardSources {
            let path = UIBezierPath()
            
            // Circles/Holes
            for column in 0..<BoardConstants.columns {
                for row in 1...BoardConstants.rows { // rect draws downwards from point
                    
                    // new point for a single rectangle cell
                    let point = delegate.getPoint(column, row)
                    let grid = CGRect(x: point.x, y: point.y, width: delegate.gridWidth * BoardConstants.widthRatio, height: delegate.gridWidth * BoardConstants.widthRatio)
                    
                    // Incircle of a rectangle
                    let centerPoint = CGPoint(x: grid.midX, y: grid.midY)
                    let circle = UIBezierPath(arcCenter: centerPoint, radius: delegate.innerDiscRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
                    path.append(circle)
                }
            }
            
            // Rounded board
            let boardRect = CGRect(
                x: delegate.startPoint.x,
                y: delegate.startPoint.y - delegate.gridWidth * CGFloat(BoardConstants.rows),
                width: delegate.gridWidth * CGFloat(BoardConstants.columns),
                height: delegate.gridWidth * CGFloat(BoardConstants.rows))
            let roundedBoard = UIBezierPath(roundedRect: boardRect, cornerRadius: delegate.gridWidth * BoardConstants.boardCornerRatio)
            path.append(roundedBoard)
            
            // Create layer
            board.path = path.cgPath
            board.lineWidth = 2
            board.fillRule = .evenOdd
            board.fillColor = ColorConstants.boardColor.cgColor
            board.strokeColor = ColorConstants.boardBorderColor.cgColor
            layer.addSublayer(board)
        }
        
        // Draw board's collider
        for (_, path) in boardColliders {
            path.lineWidth = 2
            ColorConstants.boardBorderColor.setFill()
            ColorConstants.boardBorderColor.setStroke()
            path.fill()
            path.stroke()
        }
    }
    
    func setPath(_ path: UIBezierPath?, named name: String) {
        boardColliders[name] = path
    }
    
    func deletePath(named name: String) {
        boardColliders.removeValue(forKey: name)
    }


}

// Extension to take a screenshot of my view
extension UIView {

    func takeViewScreenshot(_ size: CGSize, cgRect: CGRect) -> UIImage {
        
        // begin
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // draw view into context
        drawHierarchy(in: cgRect, afterScreenUpdates: false)
        
        // image get
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        
        return UIImage()
    }
    
}
