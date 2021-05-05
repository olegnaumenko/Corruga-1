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

    private let newsCellId = "NewsItemTableViewCell"
    private let adCellId = "AdPicTableViewCell"
    
    private var headerLabel = UILabel()
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var loadingIndicator:FTLinearActivityIndicator!
    
    internal let footerView = UITableViewHeaderFooterView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 60)))
    internal let overscrollLoadingIndicator = UIActivityIndicatorView()
    
    var viewModel:NewsViewModel!
        {
        didSet {
            self.viewModel.onRefreshNeeded = { [unowned self] in
                self.refresh()
            }
            self.viewModel.onReachabilityChange = { [unowned self] in
                self.reachabilityRefresh()
            }
        }
    }
    
    private var keyboardObserver:KeyboardPositionObserver?
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 220.0
        tableView.dataSource = self
        tableView.delegate = self
        
        overscrollLoadingIndicator.style = .gray
        
        searchController => {
            $0.searchResultsUpdater = self
            $0.hidesNavigationBarDuringPresentation = true
            $0.obscuresBackgroundDuringPresentation = false
            $0.dimsBackgroundDuringPresentation = false
            $0.searchBar.sizeToFit()
        }
        
        navigationItem.searchController = searchController

        self.keyboardObserver = KeyboardPositionObserver(onHeightChange: { (height) in
            var insets = self.tableView.contentInset
            insets.bottom = height
            self.tableView.contentInset = insets
        })
        setupFooter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = Appearance.appTintColor()
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.onViewWillAppear()
        updateLoadingIndicator()
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
    
    internal func setupHeader() -> UITableViewHeaderFooterView? {
        let isSearch = viewModel.isInSearchMode
        if (isSearch) {
            let header = tableView.headerView(forSection: 0) ?? UITableViewHeaderFooterView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 32)))
            headerLabel => {
                $0.font = UIFont.systemFont(ofSize: 14)
                $0.textColor = Appearance.labelSecondaryColor()
                $0.textAlignment = .center
                $0.text = "news-view-search-found".n10 + " \(viewModel.numberOfItems)"
                $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                $0.frame = header.bounds
            }
            if (headerLabel.superview != header) {
                headerLabel.removeFromSuperview()
                header.addSubview(headerLabel)
            }
            return header
        } else {
            headerLabel.removeFromSuperview()
        }
        return nil
    }
    
    private func updateLoadingIndicator() {
        if (viewModel.showLoadingIndicator == false)  {
            self.loadingIndicator.stopAnimating()
        } else {
            self.loadingIndicator.startAnimating()
        }
    }
    
    private func refresh() {
        self.tableView.reloadData()
        let isEmpty = self.tableView.numberOfRows(inSection: 0) == 0
        self.tableView.isHidden = isEmpty && !viewModel.isInSearchMode
        self.updateLoadingIndicator()
        self.setIndicator(on: false)
    }
    
    private func reachabilityRefresh() {
        let reachable = self.viewModel.isNetworkReachable
        self.setReachabilityIndicator(visible:!reachable)
        self.updateLoadingIndicator()
    }
    
    internal func onOverscroll() ->Bool {
        return self.viewModel.onOverscroll()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.isInSearchMode ? 32 : 0
    }
}

extension NewsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        basicScrollViewDidScroll(scrollView)
    }
}



