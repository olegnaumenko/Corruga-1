//
//  TotalLabelViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct TotalLabelViewModel {
    
    var total:Int
    
    var loaded:Bool
    
    var output:String {
        get {
            if (loaded == false) {
                return ""
            }
            
            if (total == 0) {
                return "dict-view-search-no-results".n10
            }
            return "dict-view-search-total-found".n10 + " \(total)"
        }
    }
}
