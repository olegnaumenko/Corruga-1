//
//  DataSource.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
//import RealmSwift

class DictionaryTableDataSource: NSObject, UITableViewDataSource
{
    static private let kCellID = "DictionaryEntryTableViewCell"
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryTableDataSource.kCellID, for: indexPath) as! DictionaryEntryTableViewCell
        if let entry = self.dictModel.searchResults?[indexPath.row] {
            cell.configure(entryModel: entry, toLangModel: self.dictModel.toLangModel, searchTerm: self.dictModel.currentSearchTerm)
        }
        return cell
    }
    
}
