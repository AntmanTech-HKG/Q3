//
//  BaseAPI.swift
//  Q3
//
//  Created by Anthony on 22/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [[String: Any]]

public typealias FailureHandler = ((JSONDictionary) -> Void)?
public typealias CompletionHandler = ((Any) -> Void)?


class NetworkManager {
    static let sharedInstance = NetworkManager()
    let manager: SessionManager?

    init() {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "gumtree.com": .disableEvaluation
        ]

        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
}

class BaseAPI {
    init() {

    }

    var baseURL: String {
        return "https://jobs-api.gumtree.com.au"
    }
    var apiBase: String {
        return "/api/v1"
    }

    var apiPath: String {
        return ""
    }

    var requestMethod: Alamofire.HTTPMethod {
        return .get
    }

    var params: JSONDictionary = [:]

    func defaultParams() -> JSONDictionary {
        return params
    }

    var failureHandler: FailureHandler
    var completionHandler: CompletionHandler

    func request() {
        if apiPath != "" {
            let urlString = baseURL + apiBase + apiPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

            defaultParams().forEach { (key, value) in
                params[key] = value
            }

            if let manager = NetworkManager.sharedInstance.manager {
                manager.request(urlString, method: requestMethod, parameters: params).responseJSON(completionHandler: { (response) in
//                    print("response - \(response)")
                    if var json = response.result.value as? JSONDictionary {
                        if let contentsDict = json["contents"] as? JSONDictionary  {
                            self.completionHandler?(contentsDict)
                        } else if let contentsArray = json["contents"] as? JSONArray {
                             self.completionHandler?(contentsArray)
                        } else {
                            self.failureHandler?(["status":"invalid json contents response"])
                        }
                    } else {
                        self.failureHandler?(["status":"invalid json response"])
                    }
                })
            }
        }
    }

    func handleCompletionResponse(_ response: AnyObject) {

    }

    func handleFailureResponse(_ response: AnyObject) {

    }

}
