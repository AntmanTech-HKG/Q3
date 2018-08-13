//
//  Extension+Date.swift
//  Q3
//
//  Created by Anthony on 25/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import Foundation
import DateToolsSwift

extension Date {
    
    func daySuffix() -> String {
        let calendar = NSCalendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func formattedDate() -> String {
        let format = "d'\(self.daySuffix())' MMMM yyyy"
        let string = self.format(with: format)
        return string
    }
}
