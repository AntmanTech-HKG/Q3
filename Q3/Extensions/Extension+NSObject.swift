//
//  Extension+NSObject.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import Foundation
extension NSObject {
    
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
    
    func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let terminator = "\n" + theClassName + terminator
            Swift.print(items[0], separator:separator, terminator: terminator)
        #endif
    }
}
