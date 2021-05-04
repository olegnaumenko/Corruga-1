//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import FTLinearActivityIndicator

protocol NewsViewControllerDelegate:class {
    func newsViewControllerDidSelect(item:NewsItem) -> Bool
}


class NewsViewController: BaseFeatureViewController, BasicOverScrollViewController {

    let newsCellId = "NewsItemTableViewCell"
    let adCellId = "AdPicTableViewCell"
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var logoLabel:UILabel?
    @IBOutlet weak var loadingIndicator:FTLinearActivityIndicator!
    
    let footerView = UITableViewHeaderFooterView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 60)))
    let overscrollLoadingIndicator = UIActivityIndicatorView()
    
    var viewModel:NewsViewModel!
        {
        didSet {
            self.viewModel.onRefreshNeeded = { [unowned self] in
                self.refresh()
            }
            self.viewModel.onReachabilityChange = { [unowned self] in
                let reachable = self.viewModel.isNetworkReachable
                self.setReachabilityIndicator(visible:!reachable)
                if reachable == false {
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 220.0
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        navigationItem.searchController = searchController

        if tableView.numberOfRows(inSection: 0) == 0 {
            loadingIndicator.startAnimating()
        }
        
        setupFooter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = Appearance.appTintColor()
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.onViewDidDissapear()
    }
    
//    internal func setupFooter() {
//        self.overscrollLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
//        self.overscrollLoadingIndicator.stopAnimating()
//        self.footerView.addSubview(overscrollLoadingIndicator)
//        self.tableView.tableFooterView = self.footerView
//        self.footerView.autoresizingMask = [.flexibleWidth]
//        NSLayoutConstraint.activate([
//            overscrollLoadingIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
//            overscrollLoadingIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
//        ])
//    }
    
    
    private func refresh() {
        self.tableView.reloadData()
        let isEmpty = self.tableView.numberOfRows(inSection: 0) == 0
        self.tableView.isHidden = isEmpty
        if (isEmpty == false) {
            self.loadingIndicator.stopAnimating()
        }
        self.setIndicator(on: false)
    }
    
    internal func onOverscroll() {
        self.viewModel.onOverscroll()
    }
}

extension NewsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.setSearch(term: searchController.searchBar.text)
    }
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.item(atIndex: indexPath.row)

        switch cellModel.type {
        case .newsType:
            let cell = tableView.dequeueReusableCell(withIdentifier: newsCellId, for: indexPath) as! NewsItemTableViewCell
            cell.newsItem = cellModel
            return cell
        case .adsType:
            let cell = tableView.dequeueReusableCell(withIdentifier: adCellId, for: indexPath) as! AdPicTableViewCell
            cell.viewModel = cellModel
            return cell
        }
    }
}

extension NewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!viewModel.didSelecteItem(index: indexPath.row)) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension NewsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        basicScrollViewDidScroll(scrollView)
    }
}



