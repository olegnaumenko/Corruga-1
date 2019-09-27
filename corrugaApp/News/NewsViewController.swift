//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate:class {
    func newsViewControllerDidSelect(item:NewsItem)
}


class NewsViewController: BaseFeatureViewController {

    let cellId = "NewsItemTableViewCell"
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var logoLabel:UILabel?
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    var viewModel:NewsViewModel!// = NewsViewModel(itemSource: NewsSource(itemType: .newsItemType))
        {
        didSet {
            self.viewModel.onRefreshNeeded = { [weak self] in
                if let the = self {
                    the.tableView.separatorColor = Appearance.appTintColor()
                    the.loadingIndicator.stopAnimating()
                    the.loadingIndicator.isHidden = true
                    the.tableView.reloadData()
                }
            }
            self.viewModel.viewDidLoad()
            self.title = self.viewModel.title
        }
    }
    
    weak var navigationDelegate:NewsViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
       
        self.tableView.estimatedRowHeight = 220.0
        self.tableView.separatorColor = UIColor.clear
        self.view.backgroundColor = Appearance.basicAppColor()
        self.definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDissapear()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsItemTableViewCell
        cell.newsItem = viewModel.item(atIndex: indexPath.row)
        return cell
    }
}

extension NewsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationDelegate?.newsViewControllerDidSelect(item: viewModel.item(atIndex: indexPath.row))
    }
    
}

