//
//  JobsAPI.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import Foundation

class JobsAPI: BaseAPI {
    
    var categoryId = ""
    var keyword = ""
    var size = "20"
    var page = 0

    override var apiPath: String {
        return "/jobs"
    }
    
    override func defaultParams() -> JSONDictionary {
        var params = super.defaultParams()
        params["categoryId"] = categoryId
        params["q"] = keyword
        params["size"] = size
        params["page"] = page
        
        return params
    }
}
