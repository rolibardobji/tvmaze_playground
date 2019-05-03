//
//  Environment.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import Foundation

public enum EnvironmentKey: String {
    case TVMazeAPIBaseURL = "TVMazeAPIBaseURL"
}

public struct Environment {
    
    fileprivate var infoDictionary: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    public func value(for key: EnvironmentKey) -> String {
        return (infoDictionary[key.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "") ?? ""
    }
}
