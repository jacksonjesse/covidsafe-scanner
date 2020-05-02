//
//  Utilities.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 28/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import Foundation

class Utilities {
    static func formatCalendar(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}
