//
//  TermEntity.swift
//  corruConverter
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class TermEntity: Object
{
    @objc dynamic var primary = 0
    @objc dynamic var termID = ""

    @objc dynamic var imageURL = ""
    @objc dynamic var thumbinailURL = ""
    @objc dynamic var videoURL = ""
    @objc dynamic var pageURL = ""
    @objc dynamic var dataString = ""
    @objc dynamic var dataURL = ""
    
    override static func primaryKey() -> String? {
        return "primary"
    }
    override static func indexedProperties() -> [String] {
        return ["termID"]
    }
}
