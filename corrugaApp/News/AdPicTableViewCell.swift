//
//  AdPicTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 12/17/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit


extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}

class AdPicTableViewCell: UITableViewCell {

    
    @IBOutlet weak var adImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var imageHeight:NSLayoutConstraint!
    
    var viewModel:NewsItem! {
        didSet {
            if let imagePath = viewModel.adImage {
                self.adImageView.image = UIImage(contentsOfFile: imagePath)
            }
//            if let image = self.adImageView.image {
//                self.imageHeight.constant = self.frame.width / image.getImageRatio()
//            }
            self.titleLabel.text = nil
        }
    }

}
