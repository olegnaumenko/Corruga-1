//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate:class {
    func newsViewControllerDidSelect(item url:String)
}


class NewsViewController: BaseFeatureViewController {

    let cellId = "NewsItemTableViewCell"
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var logoLabel:UILabel?
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    let viewModel = NewsViewModel()
    
    weak var navigationDelegate:NewsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appearance.basicAppColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.viewModel.onRefreshNeeded = { [weak self] in
            self?.tableView.reloadData()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
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
        self.navigationDelegate?.newsViewControllerDidSelect(item: viewModel.item(atIndex: indexPath.row).url)
    }
    
}

