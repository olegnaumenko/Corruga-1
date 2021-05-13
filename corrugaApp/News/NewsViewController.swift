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
    func newsViewControllerDidPick(item:NewsItem) -> UIViewController?
}

class NewsViewController: BaseFeatureViewController, BasicOverScrollViewController  {

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
        
        if #available(iOS 13.0, *) {
        } else {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        overscrollLoadingIndicator.style = .gray
        
        searchController => {
            $0.searchResultsUpdater = self
            $0.hidesNavigationBarDuringPresentation = true
            $0.obscuresBackgroundDuringPresentation = false
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
            if loadingIndicator.isAnimating {
                loadingIndicator.stopAnimating()
            }
        } else if !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
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
    
    private func didSelectRowAt(indexPath:IndexPath) {
        if (!self.viewModel.didSelecteItem(index: indexPath.row)) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
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
        didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.isInSearchMode ? 32 : 0
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if viewModel.item(atIndex: indexPath.row).type == .newsType {
            return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
                return self.viewModel.viewControllerForPickItem(index: indexPath.row)
            }, actionProvider: { suggestedElements in
                return self.makeContextMenu(indexPath: indexPath)
            })
        } else {
            return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil)
        }
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        didSelectRowAt(indexPath: indexPath)
    }
}

extension NewsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        basicScrollViewDidScroll(scrollView)
    }
}

extension NewsViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tv = previewingContext.sourceView as? UITableView else { return nil }
        
        if let indexPath = tv.indexPathForRow(at: location) {
            previewingContext.sourceRect = tv.rectForRow(at: indexPath)
            return viewModel.viewControllerForPickItem(index: indexPath.row)
        }
        return nil
}
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.show(viewControllerToCommit, sender: nil)
    }
}

extension NewsViewController {
    @available(iOS 13.0, *)
    func makeContextMenu(indexPath:IndexPath) -> UIMenu? {

        let item = viewModel.item(atIndex: indexPath.row)
        
        let open = UIAction(title: "Read", image: UIImage(systemName: "newspaper")) { [weak self] action in
            guard let self = self else { return }
            self.didSelectRowAt(indexPath: indexPath)
        }
        
        let share = UIAction(title: "news-coord-share-post-link".n10, image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
            guard let self = self else { return }
            self.showShareActivity(self, items: [item.url], title: nil) { (completed, activityType) in
                if (completed) {
                    AppAnalytics.shared.logEvent(name:"share_link_success", params:["activity":activityType ?? "nil"])
                } else {
                    AppAnalytics.shared.logEvent(name:"share_link_decline", params:nil)
                }
            }
        }

        let openWeb = UIAction(title: "news-coord-open-on-website".n10, image: UIImage(systemName: "safari")) { action in
            let opts = [UIApplication.OpenExternalURLOptionsKey : Any]()
            UIApplication.shared.open(item.url, options: opts, completionHandler: nil)
        }
        
        return UIMenu(children: [open, share, openWeb])
    }
}
