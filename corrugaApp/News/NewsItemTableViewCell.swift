//
//  NewsItemTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var excerptLabel:UILabel!
    @IBOutlet weak var viewsLabel:UILabel!
    
    
    
    var newsItem:NewsItem! {
        didSet {
            self.titleLabel.text = newsItem.title
            self.dateLabel.text = newsItem.date
            self.excerptLabel.text = newsItem.shortText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .gray
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
