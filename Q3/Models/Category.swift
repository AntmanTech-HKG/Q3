//
//  Category.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

open class Category: Object, Mappable {
    open dynamic var idName: String = ""
    open dynamic var localizedName: String = ""
    open dynamic var categoryId: String = ""
    open dynamic var depth: Int = 0
    var children = List<Category>()

    public required convenience init?(map: Map) {
        self.init()
    }

    override open class func primaryKey() -> String? {
        return "categoryId"
    }

    open func mapping(map: Map) {
        idName <- map["idName"]
        localizedName <- map["localizedName"]
        categoryId <- map["categoryId"]
        depth <- map["depth"]
        children <- (map["children"], ListTransform<Category>())
    }
}

struct CategoryHandler {

    static let realm = try! Realm()

    static func deletaAll() {
        let category = realm.objects(Category.self)
        try! realm.write {
            realm.delete(category)
        }
    }

    static func save(_ cat: Category) {
        
        try! realm.write {
            realm.add(cat)
        }
    }
    
//    if let count = self.categoriesList?.first?.children.count {
//        let datum = self.categoriesList![0]
//        CategoryHandler.realm.beginWrite()
//        datum.depth = 0
//        try! CategoryHandler.realm.commitWrite()
//
//        for j in 0..<datum.children.count {
//            let child = datum.children[j]
//            CategoryHandler.realm.beginWrite()
//            child.depth = 1
//            try! CategoryHandler.realm.commitWrite()
//            self.print("datum - \(child)")
//            for k in 0..<child.children.count {
//                let grand = child.children[k]
//                CategoryHandler.realm.beginWrite()
//                grand.depth = 2
//                try! CategoryHandler.realm.commitWrite()
//                self.print("datum - \(grand)")
//
//            }
//        }
//    }
    static var maxDepth = 0
    
    static func depthInputer(data: Category,_ depth: Int) {
        if depth > CategoryHandler.maxDepth {
            CategoryHandler.maxDepth = depth
        }
        
//        if data.children.count == 0 {
//            CategoryHandler.realm.beginWrite()
//            if depth != 0 {
//                data.depth = CategoryHandler.maxDepth
//            } else {
//                data.depth = 0
//            }
//            try! CategoryHandler.realm.commitWrite()
//            return
//        }
        
        CategoryHandler.realm.beginWrite()
        data.depth = depth
        try! CategoryHandler.realm.commitWrite()
        
        for index in 0..<data.children.count {
            depthInputer(data: data.children[index], depth + 1)
        }
    }
    
    static func depthRunner() {
        if let data: Category = self.realm.objects(Category.self).first {
            CategoryHandler.depthInputer(data: data, 0)
        }
        //base case
        // no children
        
    }
}
