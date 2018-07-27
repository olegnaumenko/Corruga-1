//
//  DictModel.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class DictModel {

    var storage:Storage!
    
    init(locale:String) {
        self.storage = Storage(fileName: locale)
    }
    

    
}
