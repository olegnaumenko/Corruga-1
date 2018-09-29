//
//  VideoItemTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class VideoItemTableViewCell: UITableViewCell {
    
    static let cellId = "VideoItemTableViewCell"
    
    @IBOutlet var titleLabel:UILabel!
    
    var viewModel:VideoViewModel! {
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
        
        self.titleLabel.text = self.viewModel.description
    }

}
