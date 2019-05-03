//
//  Favorite+CoreDataProperties.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var name: String?
    @NSManaged public var cover: String?
    @NSManaged public var identifer: Int64
    @NSManaged public var genres: String?
    @NSManaged public var schedule: NSSet?
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for schedule
extension Favorite {

    @objc(addScheduleObject:)
    @NSManaged public func addToSchedule(_ value: Schedule)

    @objc(removeScheduleObject:)
    @NSManaged public func removeFromSchedule(_ value: Schedule)

    @objc(addSchedule:)
    @NSManaged public func addToSchedule(_ values: NSSet)

    @objc(removeSchedule:)
    @NSManaged public func removeFromSchedule(_ values: NSSet)

}

// MARK: Generated accessors for episodes
extension Favorite {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
