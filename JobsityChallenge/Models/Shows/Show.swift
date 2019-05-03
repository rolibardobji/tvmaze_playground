//
//  Show.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit

struct Show {
    var identifier: Int
    var name: String
    var cover: String
    var summary: String
    var schedule: (String, [String])
    var genres: [String]
    var episodes: [ShowEpisode]
}
