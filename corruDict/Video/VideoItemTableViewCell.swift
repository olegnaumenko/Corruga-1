//
//  VideoItemTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import SKImageCache

class VideoItemTableViewCell: UITableViewCell {
    
    static let cellId = "VideoItemTableViewCell"
    static let cacheDirectory = "thumbCache"
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var decstiprionLabel:UILabel!
    @IBOutlet var thumbImageView:UIImageView!
    
    var viewModel:VideoItemViewModel! {
        didSet {
            self.configure()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.configure()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        
        self.titleLabel.text = self.viewModel.title
        self.decstiprionLabel.text = self.viewModel.descriptionText
        self.thumbImageView.layer.cornerRadius = 2.5
        self.thumbImageView.layer.masksToBounds = true
        if let imageURL = URL(string: self.viewModel.smallThumbURL) {
            self.thumbImageView.setImageFromURL(imageURL, placeholderImageName: nil, directory: VideoItemTableViewCell.cacheDirectory , skipCache: false, completion: nil)
        } else {
            
        }
    }

}
