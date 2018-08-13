//
//  JobDetails.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

open class Address: Object, Mappable {
    open dynamic var state: String = ""
    open dynamic var longitude: Double = 0.0
    open dynamic var latitude: Double = 0.0
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    open func mapping(map: Map) {
        state <- map["state"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
}

open class Picture: Object, Mappable {
    open dynamic var normal: String = ""
    open dynamic var large: String = ""
    open dynamic var extraLarge: String = ""
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    open func mapping(map: Map) {
        normal <- map["normal"]
        large <- map["large"]
        extraLarge <- map["extraLarge"]
    }
}

open class JobDetails: Object, Mappable {
    
    open dynamic var adType: String = ""
    open dynamic var jobId: String = ""
    open dynamic var title: String = ""
    open dynamic var jobDescription: String = ""
    open dynamic var address: Address?
    open dynamic var status: String = ""
    open dynamic var createdAt: String = ""
    open dynamic var startAt: String = ""
    open dynamic var endAt: String = ""
    open dynamic var jobType: String = ""
    open dynamic var category: String = ""
    open dynamic var location: String = ""
    open dynamic var webURL: String = ""
    var pictures = List<Picture>()
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    override open class func primaryKey() -> String? {
        return "jobId"
    }
    
    open func mapping(map: Map) {
        adType <- map["adType"]
        jobId <- map["jobId"]
        title <- map["title"]
        jobDescription <- map["description"]
        address <- map["address"]
        status <- map["status"]
        createdAt <- map["createdAt"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        jobType <- map["jobType"]
        category <- map["category"]
        location <- map["location"]
        webURL <- map["webURL"]
        pictures <- (map["pictures"], ListTransform<Picture>())
    }
}

//struct JobDetailsHandler {
//    static let realm = try! Realm()
//
//    static func deletaAll() {
//        let jobDetails = realm.objects(JobDetails.self)
//        try! realm.write {
//            realm.delete(jobDetails)
//        }
//    }
//    static func save(jobDetails: JobDetails) {
//        try! realm.write {
//            realm.add(jobDetails)
//        }
//    }
//}

