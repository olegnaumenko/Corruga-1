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
            if let image = self.adImageView.image {
                let ratio = image.getImageRatio()
                let nominalHeight:CGFloat = 76.0
                let actualHeight = 1.7 * nominalHeight / sqrt(ratio)
                self.imageHeight.constant = actualHeight
            }
            self.titleLabel.text = viewModel.title.n10
            self.selectionStyle = .none
        }
    }


}
