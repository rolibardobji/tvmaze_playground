//
//  TVMazeCommunications.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit

protocol TVMazeCommunicationsOutline {
    func series(at page: Int, completion: @escaping (([String : Any]) -> ()))
}

struct TVMazeCommunications: TVMazeCommunicationsOutline {
    func series(at page: Int, completion: @escaping (([String : Any]) -> ())) {
    }
}
