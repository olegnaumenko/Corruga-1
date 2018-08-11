//
//  PhotoViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

struct PhotoViewModel {
    
    var photoImage:UIImage? {
        didSet {
            
        }
    }
    
    var photoTitle:String {
        didSet {
            
        }
        
    }
    
    var photoDescription:String {
        didSet {
            
        }
    }
    
    var onImageSet:()->() = {}
    var onTitleSet:()->() = {}
    var onDescrSet:()->() = {}
    
    init(image:UIImage?, title:String, description:String) {
        photoTitle = title
        photoDescription = description
        photoImage = image
    }
}
