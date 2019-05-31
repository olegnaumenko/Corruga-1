//
//  UIView+Name.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

extension String {
    
    func imageNameFromJPEGPath() -> String
    {
        let nsstring = NSString(string: self).lastPathComponent.replacingOccurrences(of: ".jpg", with: "")
        return nsstring
    }
    
}
