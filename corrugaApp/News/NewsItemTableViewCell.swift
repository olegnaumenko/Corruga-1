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
    @IBOutlet weak var adImageView:UIImageView!
    
    let emojiHtmlRegex = "\\&#x(.*)\\;"
    
    var newsItem:NewsItem! {
        didSet {
            self.titleLabel.text = newsItem.title
            self.dateLabel.text = newsItem.date
            let excerpt = newsItem.shortText
            
            
            //replace emoji if any
            do {
                let regex = try NSRegularExpression(pattern: emojiHtmlRegex, options: [])
                
                let num = regex.numberOfMatches(in: newsItem.shortText, options: [], range: NSMakeRange(0, newsItem.shortText.count))
                
                if num == 0 {
                    self.excerptLabel.text = excerpt
                    return
                }
                
                let range = NSRange(excerpt.startIndex..., in: excerpt)
                let newExcerpt = regex.stringByReplacingMatches(in: excerpt, options: [], range: range, withTemplate: "")
                //"\u{$1}"
                self.excerptLabel.text = newExcerpt
            } catch {

                self.excerptLabel.text = excerpt
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .gray
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil;
        dateLabel.text = nil
        excerptLabel.text = nil
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
