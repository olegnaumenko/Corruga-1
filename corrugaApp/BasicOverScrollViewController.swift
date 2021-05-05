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
    func onOverscroll() -> Bool
}

extension BasicOverScrollViewController {
    func setupFooter() {
        overscrollLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        overscrollLoadingIndicator.stopAnimating()
        footerView.addSubview(overscrollLoadingIndicator)
        footerView.autoresizingMask = [.flexibleWidth]
        tableView.tableFooterView = footerView
        NSLayoutConstraint.activate([
            overscrollLoadingIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            overscrollLoadingIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
        ])
    }
    
    func onOverscrollInternal() {
        if (onOverscroll() == true) {
            overscrollLoadingIndicator.startAnimating()
        }
    }
    
    func setIndicator(on:Bool) {
        on == true ? overscrollLoadingIndicator.startAnimating() : overscrollLoadingIndicator.stopAnimating()
    }

    func basicScrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio = (scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height))
        if (ratio > 0.9) {
            onOverscrollInternal()
        }
    }
}
