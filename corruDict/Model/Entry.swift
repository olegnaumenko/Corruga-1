//
//  Entry.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object
{
    @objc dynamic var primary = 0
    @objc dynamic var id = ""
    @objc dynamic var entry = ""
    @objc dynamic var translation = ""
    
    override static func primaryKey() -> String? {
        return "primary"
    }
    override static func indexedProperties() -> [String] {
        return ["entry", "translation"]
    }
}
