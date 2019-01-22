//
//  NewsItemEntity.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/16/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class NewsItemEntity : Object {
    
    @objc dynamic var index = 0
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var shortText = ""
    @objc dynamic var articleURL = ""
    @objc dynamic var titleImageURL = ""
    @objc dynamic var dateAdded = ""
    @objc dynamic var numberOfViews = 0
}
