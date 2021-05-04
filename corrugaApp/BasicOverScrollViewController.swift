//
//  BasicOverScrollViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 04.05.2021.
//  Copyright © 2021 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

protocol BasicOverScrollViewController:UIScrollViewDelegate {
    
    var tableView:UITableView! { get set }
    
    var footerView:UITableViewHeaderFooterView { get }
    var overscrollLoadingIndicator:UIActivityIndicatorView { get }
    func onOverscroll()
}

extension BasicOverScrollViewController {
    func setupFooter() {
        self.overscrollLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.overscrollLoadingIndicator.stopAnimating()
        self.footerView.addSubview(overscrollLoadingIndicator)
        self.tableView.tableFooterView = self.footerView
        self.footerView.autoresizingMask = [.flexibleWidth]
        NSLayoutConstraint.activate([
            overscrollLoadingIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            overscrollLoadingIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
        ])
    }
    
    func onOverscrollInternal() {
        self.overscrollLoadingIndicator.startAnimating()
        self.onOverscroll()
    }
    
    func setIndicator(on:Bool) {
        on == true ? overscrollLoadingIndicator.startAnimating() : overscrollLoadingIndicator.stopAnimating()
    }

    func basicScrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio = (scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height))
        if (ratio > 0.9) {
            self.onOverscrollInternal()
        }
    }
}
