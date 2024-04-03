//
//  DateUtils.swift
//  geber
//
//  Created by bernanda on 31/03/24.
//

import Foundation


final class DateUtils {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
}
