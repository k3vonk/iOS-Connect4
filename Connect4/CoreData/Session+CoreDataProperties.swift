////  Session+CoreDataProperties.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/23.
//  Copyright © 2020 CS UCD. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var move: Moves?
    @NSManaged public var outcome: String?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var winningPieces: [Int16]?
    @NSManaged public var botStart: Bool

}
