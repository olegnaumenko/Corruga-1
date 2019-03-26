//
//  VideoItemTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import AltHaneke

class VideoItemTableViewCell: UITableViewCell {
    
    static let cellId = "VideoItemTableViewCell"
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var decstiprionLabel:UILabel!
    @IBOutlet var thumbImageView:UIImageView!
    
    var viewModel:VideoItemViewModel! {
        didSet {
            self.configure()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.thumbImageView.layer.cornerRadius = 2.5
        self.thumbImageView.layer.masksToBounds = true
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func prepareForReuse() {
        self.thumbImageView.hnk_cancelSetImage()
        self.thumbImageView.image = nil
    }
    
    func configure() {
        
        self.titleLabel.text = self.viewModel.title
        self.decstiprionLabel.text = self.viewModel.descriptionText
        if let imageURL = URL(string: self.viewModel.mediumThumbURL) {
            self.thumbImageView.hnk_setImageFromURL(imageURL)
        }
    }
}
