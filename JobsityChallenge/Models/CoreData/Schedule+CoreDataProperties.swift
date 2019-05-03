//
//  Schedule+CoreDataProperties.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var day: String?
    @NSManaged public var time: String?
    @NSManaged public var favorite: NSSet?

}

// MARK: Generated accessors for favorite
extension Schedule {

    @objc(addFavoriteObject:)
    @NSManaged public func addToFavorite(_ value: Favorite)

    @objc(removeFavoriteObject:)
    @NSManaged public func removeFromFavorite(_ value: Favorite)

    @objc(addFavorite:)
    @NSManaged public func addToFavorite(_ values: NSSet)

    @objc(removeFavorite:)
    @NSManaged public func removeFromFavorite(_ values: NSSet)

}
