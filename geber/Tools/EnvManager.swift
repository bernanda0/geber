//
//  EnvManager.swift
//  geber
//
//  Created by bernanda on 31/03/24.
//

import Foundation


final class EnvManager {
    static let shared = EnvManager()
    @Published var REDIS_HOST : String
    @Published var REDIS_USER : String
    @Published var REDIS_PASS : String
    
    private init() {
        let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
        
        REDIS_HOST = envDict["REDIS_HOST"]!
        REDIS_USER = envDict["REDIS_USER"]!
        REDIS_PASS = envDict["REDIS_PASS"]!
    }
}
