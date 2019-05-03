//
//  ShowEpisodesTVMazeOperations.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/30/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit

enum ShowEpisodesResponse {
    case success([ShowEpisode])
    case error(String)
}

class ShowEpisodesTVMazeOperations: NSObject {
    private var API: TVMazeCommunicationsOutline
    
    init(api: TVMazeCommunicationsOutline) {
        API = api
    }
    
    func episodes(for show: Int, completion: @escaping ((ShowEpisodesResponse) -> ())) {
        self.API.episodes(for: show, completion: { (response) in
            switch response {
            case .success(let episodesData):
                let episodesJSON = episodesData as! [[String : Any]]
                let episodes: [ShowEpisode] = episodesJSON.map {
                    let identifier = $0["id"] as! Int
                    let name = $0["name"] as! String
                    let summary = $0["summary"] as? String ?? ""
                    let number = $0["number"] as! Int
                    let season = $0["season"] as! Int
                    
                    var cover = ""
                    if let coverJSON = $0["image"] as? [String : Any] {
                        cover = coverJSON["medium"] as! String
                    }
                    
                    return ShowEpisode(identifier: identifier, name: name, number: number, season: season, summary: summary, cover: cover)
                }
                
                completion(.success(episodes))
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
