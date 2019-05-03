//
//  Episode+CoreDataProperties.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: Int16
    @NSManaged public var season: Int16
    @NSManaged public var summary: String?
    @NSManaged public var image: String?
    @NSManaged public var favorite: Favorite?

}
