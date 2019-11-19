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
    
    var output:String {
        get {
            if (total == 0) {
                return "No results found. Try again."
            }
            return "Total terms found: \(total)"
        }
    }
}
