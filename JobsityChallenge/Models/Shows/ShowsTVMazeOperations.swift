//
//  ShowsTVMazeOperations.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

enum ShowsResponse {
    case success([Show])
    case error(String)
}

class ShowsTVMazeOperations: NSObject {
    private var API: TVMazeCommunicationsOutline
    
    init(api: TVMazeCommunicationsOutline) {
        API = api
    }
    
    func tvShows(at page: Int, completion: @escaping ((ShowsResponse) -> ())) {
        self.API.shows(at: page, completion: { (response) in
            switch response {
            case .success(let showsData):
                let showsJSON = showsData as! [[String : Any]]
                let shows: [Show] = showsJSON.map {
                    let identifier = $0["id"] as! Int
                    let name = $0["name"] as! String
                    let summary = $0["summary"] as? String ?? ""
                    
                    var schedule: (String, [String]) = ("", [])
                    if let scheduleJSON = $0["schedule"] as? [String : Any] {
                        schedule = (scheduleJSON["time"] as! String, scheduleJSON["days"] as! [String])
                    }
                    
                    var cover = ""
                    if let coverJSON = $0["image"] as? [String : Any] {
                        cover = coverJSON["medium"] as! String
                    }
                    
                    let genres: [String] = $0["genres"] as! [String]
                    
                    return Show(identifier: identifier, name: name, cover: cover, summary: summary, schedule: schedule, genres: genres, episodes: [])
                }
                
                completion(.success(shows))
            case .error(let error):
                switch error {
                case .networkConnection:
                    completion(.error("No network connectivity"))
                case .serverError:
                    completion(.error("There was a problem with the server"))
                case .serviceError(let serviceError):
                    completion(.error(serviceError))
                }
                break
            }
        })
    }
    
    func search(show: String, completion: @escaping ((ShowsResponse) -> ())) {
        self.API.search(show: show, completion: { (response) in
            switch response {
            case .success(let showsData):
                let showsJSON = showsData as! [[String : Any]]
                let shows: [Show] = showsJSON.map {
                    let show = $0["show"] as! [String : Any]
                    let identifier = show["id"] as! Int
                    let name = show["name"] as! String
                    let summary = show["summary"] as? String ?? ""
                    
                    var schedule: (String, [String]) = ("", [])
                    if let scheduleJSON = show["schedule"] as? [String : Any] {
                        schedule = (scheduleJSON["time"] as! String, scheduleJSON["days"] as! [String])
                    }
                    
                    var cover = ""
                    if let coverJSON = show["image"] as? [String : Any] {
                        cover = coverJSON["medium"] as! String
                    }
                    
                    let genres: [String] = show["genres"] as! [String]
                    
                    return Show(identifier: identifier, name: name, cover: cover, summary: summary, schedule: schedule, genres: genres, episodes: [])
                }
                
                completion(.success(shows))
            case .error(let error):
                switch error {
                case .networkConnection:
                    completion(.error("No network connectivity"))
                case .serverError:
                    completion(.error("There was a problem with the server"))
                case .serviceError(let serviceError):
                    completion(.error(serviceError))
                }
                break
            }
        })
    }
}
