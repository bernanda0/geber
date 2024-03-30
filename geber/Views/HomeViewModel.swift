//
//  HomeViewModel.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import Foundation
import SwiftyRedis
import SwiftRedis

final class HomeViewModel: ObservableObject {
    @Published var events: String = ""
    private var REDIS_CONNECTION_URL = ""
    private let redis = Redis()

    
    init() {
        redis.connect(host: "admin.netlabdte.com", port: 6379) { (redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else {
                print("Connected to Redis")
                redis.auth("41319922e9d9d10029c3") { (err : NSError?) in
                    if let error = redisError {
                        print(error)
                    }
                    
                    updateMessage(msg: "Redis connection established")
                }
                
            }
        }
    }
    
    func setVal(input: String) {
        // Set a key
        redis.set("Redis", value: input) { (result: Bool, redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            
            else {
                print("Success set data")
            }
        }
    }
    
    func getValue(){
        redis.get("Redis") { (string: RedisString?, redisError: NSError?) in
                        if let error = redisError {
                            print(error)
                        }
                        else if let string = string?.asString {
                            updateMessage(msg: string)
                        }
        }
    }

    
    func updateMessage(msg: String) {
        events = msg
    }
}
