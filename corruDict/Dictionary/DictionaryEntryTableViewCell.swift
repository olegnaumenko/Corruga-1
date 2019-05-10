//
//  DictionaryEntryTableViewCell.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/9/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class DictionaryEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel:UILabel!
    @IBOutlet weak var transcriptionLabel:UILabel!
    @IBOutlet weak var translationLabel:UILabel!
    
    func configure(entryModel:TranslationEntryModel, toLangModel:LanguageModel, searchTerm:String) {
        self.entryModel = entryModel
        toLangModel.translation(withID: entryModel.id) { (optionalTranslatedEntryModel, optionalError) in
            if let translated = optionalTranslatedEntryModel, translated.id == self.entryModel.id {
                self.translationLabel.text = translated.value
            }
        }
        
        let range = (entryModel.value as NSString).range(of: searchTerm)
        
        let attrString = NSMutableAttributedString(string: entryModel.value)
        let attrs = [convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor) : Appearance.highlightedTextColor()]
        attrString.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(attrs), range: range)
        
        valueLabel.attributedText = attrString
        transcriptionLabel.text = entryModel.transcription.count > 0 ? String.init(format: "[ %@ ]", entryModel.transcription) : nil
    }
    
    
    var entryModel:TranslationEntryModel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
}
