//
//  ImageProvider.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/9/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class ImageProvider {
    
    private static let thumbsDIR = "CorrugaImageThumbs"
    private static let imagesDIR = "CorrugaImages"
    
    private var imageNames:[String] = []
    
    init() {
        scanImages()
    }
    
    func scanImages() {
        let thumbs = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: ImageProvider.imagesDIR)
        self.imageNames = thumbs
    }
    
    func imageCount() -> Int {
        return self.imageNames.count
    }
    
    func imageNameAtIndex(index:Int) -> String {
        return self.imageNames[index]
    }
    
    func randomImageName() -> String {
        let index = Int.random(in: 0 ..< self.imageCount())
        return self.imageNameAtIndex(index: index)
    }
}
