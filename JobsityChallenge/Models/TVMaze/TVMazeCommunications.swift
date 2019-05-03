//
//  TVMazeCommunications.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import Alamofire

struct TVMazeAPIEndpoints {
    static let shows = "/shows"
    static let episodes = "/episodes"
    static let search = "/search"
}

protocol TVMazeCommunicationsOutline {
    func shows(at page: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ()))
    func episodes(for show: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ()))
    func search(show: String, completion: @escaping ((TVMazeCommunicationsResponse) -> ()))
}

enum TVMazeCommunicationsError: Error {
    case networkConnection
    case serverError
    case serviceError(String)
}

enum TVMazeCommunicationsResponse {
    case success(Any)
    case error(TVMazeCommunicationsError)
}

struct TVMazeCommunications: TVMazeCommunicationsOutline {
    private var environment: Environment
    
    func shows(at page: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        Alamofire.request("\(environment.value(for: .TVMazeAPIBaseURL))\(TVMazeAPIEndpoints.shows)", method: .get, parameters: ["page" : page] as Parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                if let responseJSON = response.result.value as? [[String : Any]] {
                    completion(.success(responseJSON))
                } else {
                    completion(.error(.serviceError("Shows data malformed")))
                }
            } else {
                self.evaluateError(for: response, completion: completion)
            }
        }
    }
    
    func search(show: String, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        Alamofire.request("\(environment.value(for: .TVMazeAPIBaseURL))\(TVMazeAPIEndpoints.search)\(TVMazeAPIEndpoints.shows)", method: .get, parameters: ["q" : show] as Parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                if let responseJSON = response.result.value as? [[String : Any]] {
                    completion(.success(responseJSON))
                } else {
                    completion(.error(.serviceError("Shows data malformed")))
                }
            } else {
                self.evaluateError(for: response, completion: completion)
            }
        }
    }
    
    func episodes(for show: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        Alamofire.request("\(environment.value(for: .TVMazeAPIBaseURL))\(TVMazeAPIEndpoints.shows)/\(show)\(TVMazeAPIEndpoints.episodes)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                if let responseJSON = response.result.value as? [[String : Any]] {
                    completion(.success(responseJSON))
                } else {
                    completion(.error(.serviceError("Episodes data malformed")))
                }
            } else {
                self.evaluateError(for: response, completion: completion)
            }
        }
    }
    
    private func evaluateError(for response: DataResponse<Any>, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        switch response.response?.statusCode ?? 0 {
        case 400...499:
            completion(.error(.serverError))
        case 500...599:
            completion(.error(.serverError))
        case -1005, -1009:
            completion(.error(.networkConnection))
        default:
            completion(.error(.serverError))
        }
    }
    
    init(environment: Environment) {
        self.environment = environment
    }
}
