//
//  Event.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import Foundation

struct Event {
    let event_id: String
    let location: SectionLocation
    let timestamp: Date
}

enum SectionLocation {
    case s1, s2, s3
}


