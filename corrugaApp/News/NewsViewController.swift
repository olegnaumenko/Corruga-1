//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate:class {
    func newsViewControllerDidSelect(post:NewsOpenPost) -> Bool
}


class NewsViewController: BaseFeatureViewController {

    let newsCellId = "NewsItemTableViewCell"
    let adCellId = "AdPicTableViewCell"
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var logoLabel:UILabel?
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    var viewModel:NewsViewModel!
        {
        didSet {
            self.viewModel.onRefreshNeeded = { [unowned self] in
                self.refresh()
            }
            self.viewModel.onReachabilityChange = { [unowned self] in
                self.setReachabilityIndicator(visible:!self.viewModel.isNetworkReachable)
            }
            self.title = self.viewModel.title
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
       
        self.tableView.estimatedRowHeight = 220.0
        self.tableView.separatorColor = UIColor.clear
        self.tableView.prefetchDataSource = self
        self.definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = searchController

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.onViewDidDissapear()
    }
    
    
    private func refresh() {
        self.tableView.separatorColor = Appearance.appTintColor()
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.tableView.reloadData()
        self.tableView.isHidden = self.tableView.numberOfRows(inSection: 0) == 0
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

extension NewsViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
//        guard let min = indexPaths.min()?.row, let max = indexPaths.max()?.row
//        else {
//            return
//        }
//        self.viewModel.prefetchItems(firstIndex: min, lastIndex: max)
        

//        print("prefetch: \(indexPaths) visible: \(tableView.indexPathsForVisibleRows)")
    }
    
    
}

