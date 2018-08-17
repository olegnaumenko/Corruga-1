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
        get {
            return UIImage(contentsOfFile: self.photoImagePath)
        }
    }
    
    var photoImagePath:String
    
    var photoTitle:String {
        get {
            return self.photoImagePath.imageNameFromPath()
        }
    }
    
    var photoDescription:String
    
    var onImageSet:()->() = {}
    var onTitleSet:()->() = {}
    var onDescrSet:()->() = {}
    
    init(imagePath:String, description:String) {
        photoDescription = description
        photoImagePath = imagePath
    }
}
