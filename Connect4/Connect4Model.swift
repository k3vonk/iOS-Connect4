////  Connect4Model.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation
import CoreGraphics

class Connect4Model {
    
    func getGridWidth(_ gameBoardWidth: CGFloat) -> CGFloat{
        return gameBoardWidth / CGFloat(BoardConstants.columns)
    }
    
    func getInnerDiscRadius(_ gameBoardWidth: CGFloat) -> CGFloat {
        let gridWidth = getGridWidth(gameBoardWidth)
        return (gridWidth / CGFloat(2.0)) * BoardConstants.innerDiscRatio
    }
    
    func getStartPoint(_ gameBoardWidth: CGFloat, _ gameBoardCenter: CGPoint) -> CGPoint{
        let gridWidth = getGridWidth(gameBoardWidth)
        let leftOverSpace = gameBoardWidth.remainder(dividingBy: gridWidth)
        
        // Bottom left starting point
        let x = gameBoardCenter.x - ((gameBoardWidth - leftOverSpace) / CGFloat(2.0))
        let y = gameBoardCenter.y + ((CGFloat(BoardConstants.rows) * gridWidth) / CGFloat(2.0))
        
        return CGPoint(x: x, y: y)
    }
    
    func getPoint(_ gameBoardWidth: CGFloat,_ gameBoardCenter: CGPoint, _ column: Int, _ row: Int) -> CGPoint {
        let gridWidth = getGridWidth(gameBoardWidth)
        let startPoint = getStartPoint(gameBoardWidth, gameBoardCenter)
        let shiftRight = getShiftRight(gameBoardWidth)
        let shiftUp = getShiftUp(gameBoardWidth)
        
        
        
        let newX = startPoint.x + CGFloat(column) * gridWidth + shiftRight / CGFloat(2.0)
        let newY = startPoint.y - CGFloat(row) * gridWidth * BoardConstants.widthRatio - shiftUp
        
        return CGPoint(x: newX, y: newY)
    }
    
    private func getShiftRight(_ gameBoardWidth: CGFloat) -> CGFloat {
        let gridWidth = getGridWidth(gameBoardWidth)
        return gridWidth - gridWidth * BoardConstants.widthRatio
    }
    
    func getShiftUp(_ gameBoardWidth: CGFloat) -> CGFloat {
        let gridWidth = getGridWidth(gameBoardWidth)
        let shift: CGFloat = (gridWidth * CGFloat(BoardConstants.rows) - gridWidth * CGFloat(BoardConstants.rows) * BoardConstants.widthRatio) / CGFloat(2.0)

        return shift
    }
    

}
