//
//  TranslationEntity.swift
//  corruConverter
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class TranslationEntity: Object
{
//    @objc dynamic var primary = 0
    
    @objc dynamic var index = 0
    @objc dynamic var termID = ""
    @objc dynamic var stringValue = ""
    @objc dynamic var languageID = ""
    @objc dynamic var dataURL = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var imageURL2 = ""
    
//    override static func primaryKey() -> String? {
//        return "primary"
//    }
    
    override static func indexedProperties() -> [String] {
        return ["termID", "stringVaue"]
    }
}
