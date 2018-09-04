//
//  SpotlightIndexer.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

struct Match {
    var id:String?
    var title:String
    var content:String?
    var image:Data?
}

class SpotlightIndexer: NSObject {

    func indexSearchable(matches:[Match]) {

        var searchableItems = [CSSearchableItem]()
        
        for match in matches {
            let searchItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchItemAttributeSet.title = match.title
            searchItemAttributeSet.contentDescription = match.content
            searchItemAttributeSet.thumbnailData = match.image
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: match.id, domainIdentifier: "matches", attributeSet: searchItemAttributeSet)
            searchableItems.append(searchableItem)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
}
