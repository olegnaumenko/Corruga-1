//
//  DataSource.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DataSource:NSObject, UITableViewDataSource
{
    static private let kCellID = "EntryCell"
    
    private let dictModel:DictModel
    var displayedEntries:Results<TranslationEntity>?
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.displayedEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataSource.kCellID, for: indexPath)
        if let entry = self.displayedEntries?[indexPath.row] {
            cell.textLabel?.text = entry.stringValue
            cell.detailTextLabel?.text = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
            
            let isEven = (Int(indexPath.row % 2) == 0)
            cell.backgroundColor = UIColor.init(white: isEven ? 0.96 : 1.0, alpha: 1)
        }
        return cell
    }
    
    
}
