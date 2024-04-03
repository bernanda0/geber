//
//  Event.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import Foundation

struct Pet {
    let name : String
    
}

struct Event : Codable {
    let location: SectionLocation
    let timestamp: Date
}

enum SectionLocation : Codable {
    case s1, s2, s3
}


