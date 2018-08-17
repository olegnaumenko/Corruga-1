//
//  DetailViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct DetailViewModel {
    
    var term = ""
    var translation = ""
    var langID = "en-US"
    var entry:TranslationEntity
    var imagePath:String = ""
    
    func imageName() -> String
    {
        let nsstring = NSString(string: imagePath).lastPathComponent.replacingOccurrences(of: ".jpg", with: "")
        return nsstring
    }
}