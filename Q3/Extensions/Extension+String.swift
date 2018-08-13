//
//  Extension+String.swift
//  Q3
//
//  Created by Anthony on 25/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import Foundation

extension String {
    
    func depthIndicator(_ depth: Int, withPad character: Character) -> String {
        return String(repeatElement(character, count: depth)) + " " + self
    }
    
    func formatToDayOnly() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = formatter.date(from: self) else { return "" }
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        
        // again convert your date to string
        return date.formattedDate()
    }
}
