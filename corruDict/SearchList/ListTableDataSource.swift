//
//  DataSource.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableDataSource: NSObject, UITableViewDataSource
{
    static private let kCellID = "EntryCell"
    
    private let dictModel:DictModel
    
//    var displayedEntries:Results<TranslationEntity>?
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        super.init()
    }
    
    func resultsCount() -> Int {
        return  self.dictModel.searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableDataSource.kCellID, for: indexPath)
        if let entry = self.dictModel.searchResults?[indexPath.row] {
            
            let translation = self.dictModel.toStorage.translation(withID: entry.termID)
            
            let cellViewModel = ListCellViewModel(entry: entry, translation: translation, index: indexPath.row, searchTerm: self.dictModel.currentSearchTerm)
            
            cell.textLabel?.attributedText = cellViewModel.title
            cell.detailTextLabel?.text = cellViewModel.subtitle
            cell.backgroundColor = cellViewModel.backgroundColor
        }
        return cell
    }
    
    func footerTotal() -> String {
        return TotalLabelViewModel(total: self.dictModel.searchResults?.count ?? 0).output
    }
    
    func languagesLabel() -> String {
        if let fromLang = self.dictModel.fromStorage.languageID.components(separatedBy: "_").first,
            let toLang = self.dictModel.toStorage.languageID.components(separatedBy: "_").first
        {
            return "\(fromLang.uppercased()) -> \(toLang.uppercased())"
        }
        
        return "XX -> YY"
    }
}
