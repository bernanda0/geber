//
//  HomeViewModel.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import Foundation
import SwiftyRedis
import SwiftRedis
import Network

final class HomeViewModel: ObservableObject {
    @Published var events: String = ""
    
//    using Kitura
    private let redis = Redis()

//    using SwiftyMerah
    private let client = RedisClient(NWEndpoint.Host(EnvManager.shared.REDIS_HOST), username: EnvManager.shared.REDIS_USER, password: EnvManager.shared.REDIS_PASS)
    
    init() {
        redis.connect(host: EnvManager.shared.REDIS_HOST, port: 6379) { (redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else {
                print("Connected to Redis")
                redis.auth(EnvManager.shared.REDIS_PASS) { (err : NSError?) in
                    if let error = redisError {
                        print(error)
                    }
                    
                    updateMessage(msg: "Redis connection established")
                }
                
            }
        }
    }
    
    func connect() async {
        do {
            let a = try await client.get_pub_sub_connection()
            try await a.psubscribe("__key*__:*")
            let messageStream = await a.messages()
            
            Task.init {
                do {
                    for await _ in messageStream {
                        await MainActor.run {
                            getValue()
                        }
                        
                    }
                }
            }
        } catch {
            print("\(error)")
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
                        } else {
                            updateMessage(msg: "EMPTY")
                        }
        }
        
    }
    
    func updateMessage(msg: String) {
        events = msg
    }
    
    func expireKey() async {
        do {
            let b = try await client.get_connection()
            
            try await b.expire("Redis", 0)
        } catch {
            
        }
       
    }
}
