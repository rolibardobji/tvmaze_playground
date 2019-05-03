//
//  ShowsTVMazeOperationsTests.swift
//  JobsityChallengeTests
//
//  Created by Ronny Libardo Bustos Jiménez on 5/2/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import XCTest
@testable import JobsityChallenge

class ShowsTVMazeOperationsTests: XCTestCase {
    
    struct TVMazeCommunicationsMock: TVMazeCommunicationsOutline {
        private let testJSON = [
            [
                "id": 1,
                "url": "http://www.tvmaze.com/shows/1/under-the-dome",
                "name": "Under the Dome",
                "type": "Scripted",
                "language": "English",
                "genres": [
                    "Drama",
                    "Science-Fiction",
                    "Thriller"
                ],
                "status": "Ended",
                "runtime": 60,
                "premiered": "2013-06-24",
                "officialSite": "http://www.cbs.com/shows/under-the-dome/",
                "schedule": [
                    "time": "22:00",
                    "days": [
                        "Thursday"
                    ]
                ],
                "rating": [
                    "average": 6.5
                ],
                "weight": 94,
                "network": [
                    "id": 2,
                    "name": "CBS",
                    "country": [
                        "name": "United States",
                        "code": "US",
                        "timezone": "America/New_York"
                    ]
                ],
                "webChannel": NSNull.init(),
                "externals": [
                    "tvrage": 25988,
                    "thetvdb": 264492,
                    "imdb": "tt1553656"
                ],
                "image": [
                    "medium": "http://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                    "original": "http://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"
                ],
                "summary": "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>",
                "updated": 1549572248,
                "_links": [
                    "self": [
                        "href": "http://api.tvmaze.com/shows/1"
                    ],
                    "previousepisode": [
                        "href": "http://api.tvmaze.com/episodes/185054"
                    ]
                ]
            ]
        ]
        
        func shows(at page: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
            completion(.success(testJSON))
        }
        
        func search(show: String, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        }
        
        func episodes(for show: Int, completion: @escaping ((TVMazeCommunicationsResponse) -> ())) {
        }
    }
    
    let showsTVMazeOperations = ShowsTVMazeOperations(api: TVMazeCommunicationsMock())
    
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testTVShowsAtPageSucceeds() {
        showsTVMazeOperations.tvShows(at: 0) { (response) in
            switch response {
            case let .success(shows):
                XCTAssertTrue(shows.first?.identifier == 1)
            case .error(_):
                XCTFail()
            }
        }
    }

}
