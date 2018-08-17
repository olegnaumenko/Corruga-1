//
//  ListScrollManager.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit



protocol ScrollManagerDelegate:class
{
    func scrollManagerTableviewCellTapped()
}

class ScrollManager:NSObject
{
    let tableView:UIScrollView
    let responder:UIResponder
    
    var draggingScrollview = false
    var dragStartOffset = CGFloat(0.0)
    
    weak var delegate:ScrollManagerDelegate?
    
    init(tableView:UITableView, responder:UIResponder) {
        self.tableView = tableView
        self.responder = responder
        super.init()
        tableView.delegate = self
    }
}

extension ScrollManager : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.responder.resignFirstResponder()
        self.delegate?.scrollManagerTableviewCellTapped()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.dragStartOffset > scrollView.contentOffset.y) &&
            self.draggingScrollview == true {
            self.responder.resignFirstResponder()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.draggingScrollview = true
        self.dragStartOffset = scrollView.contentOffset.y
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.draggingScrollview = false
    }
}
