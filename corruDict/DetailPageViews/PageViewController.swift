//
//  PageViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var pageDataSource:PageViewDatasource?
    {
        didSet {
            self.dataSource = pageDataSource
        }
    }
    
    var pageViewCoordinator:PageViewCoordinator?
    {
        didSet {
            self.pageDataSource = pageViewCoordinator?.pageViewDataSource
        }
    }
    
    private lazy var tapGestureReco = UITapGestureRecognizer(target: self, action: #selector(self.onTap(sender:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let ds = self.dataSource as! PageViewDatasource
        if let vc = ds.viewControllerForIndex(index: ds.currentIndex) {
            self.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        self.view.backgroundColor = Appearance.basicAppColor()
//        self.view.addGestureRecognizer(self.tapGestureReco)
    }
    
    
    @objc func onTap(sender: UITapGestureRecognizer)
    {
        
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
