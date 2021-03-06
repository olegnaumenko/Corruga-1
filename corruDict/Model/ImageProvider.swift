//
//  ImageProvider.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/9/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class ImageProvider {
    
//    private let kThumbsDIR = "images/CorrugaImageThumbs"
    private let kImagesDIR = "images/CorrugaImages"
    private let kImagesEXT = "jpg"
    
    private var imageNames:[String] = []
    
    init() {
        self.scanImages()
    }
    
    func scanImages() {
        DispatchQueue.global().async {
            let thumbs = Bundle.main.paths(forResourcesOfType: self.kImagesEXT, inDirectory: self.kImagesDIR)
            DispatchQueue.main.async {
                self.imageNames = thumbs
            }
        }
    }
    
    func imageCount() -> Int {
        return self.imageNames.count
    }
    
    func imageNameAt(index:Int) -> String {
        return self.imageNames[index]
    }
    
    func randomImageName() -> String {
        let imgCount = self.imageCount()
        if imgCount == 0 {
            return ""
        }
        let index = Float(arc4random())/Float(UInt32.max) * Float(imgCount)
//        let index = Int.random(in: 0 ..< self.imageCount())
        return self.imageNameAt(index: Int(index))
    }
}
