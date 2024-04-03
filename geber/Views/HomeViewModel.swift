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
    @Published var message: String = ""
    @Published var current_key_event: String = ""
    
    private let default_msg = "READY TO CALL HELP"
    private let currentKeyEventKey = "currentKeyEvent"
    private let redis = Redis()
    
    init() {
        
        if let storedKey = UserDefaults.standard.string(forKey: currentKeyEventKey) {
            current_key_event = storedKey
        }
        
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
                    
                    getValue(key: current_key_event)
                }
                
            }
        }
    }
    
    private func saveCurrentKeyEvent() {
        UserDefaults.standard.set(current_key_event, forKey: currentKeyEventKey)
    }
    
    func setVal(input: String) {
        redis.set("Redis", value: input) { (result: Bool, redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            
            else {
                print("Success set data")
            }
        }
    }
    
    
    func getValue(key: String){
        redis.hget(key, field: "event_data") { (string: RedisString?, redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else if let string = string?.asString {
                updateMessage(msg: string)
            } else {
                updateMessage(msg: default_msg)
            }
        }
    }
    
    func updateMessage(msg: String) {
        message = msg
    }
    
    func expireHelp(key: String) {
        redis.expire(key, inTime: 0) { (success: Bool, err: NSError?) in
            if let error = err {
                print(error)
            } else {
                if (success) {
                    current_key_event = ""
                    saveCurrentKeyEvent()
                    updateMessage(msg: default_msg)
                }
            }
        }
    }
    
    func getHelp() {
        do {
            let event = Event(location: SectionLocation.s1, timestamp: Date())
            let timeInterval = Int(event.timestamp.timeIntervalSince1970)
            let key = "\(event.location)_event_\(timeInterval)"
            
            let jsonData = try JSONEncoder().encode(event)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            redis.hset(key, field: "event_data", value: jsonString!){ (result: Bool, redisError: NSError?) in
                if let error = redisError {
                    print(error)
                }
                
                else {
                    current_key_event = key
                    saveCurrentKeyEvent()
                    PushNotificationActor.pushNotification(loc: "\(event.location)")
                    getValue(key: key)
                }
            }
            
        } catch {
            
        }
        
    }
}
