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
    private var storage:Storage?
    var displayedEntries:Results<Entry>?
    
    init(storage:Storage) {
        super.init()
        self.storage = storage
        self.update()
    }
        
    func update()
    {
        self.displayedEntries = self.storage?.allEntries()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.displayedEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        if let entry = self.displayedEntries?[indexPath.row] {
            cell.textLabel?.text = entry.translation
            cell.detailTextLabel?.text = entry.entry
            
            let isEven = (Int(indexPath.row % 2) == 0)
            cell.backgroundColor = UIColor.init(white: isEven ? 0.96 : 1.0, alpha: 1)
        }
        return cell
    }
    
    
}
