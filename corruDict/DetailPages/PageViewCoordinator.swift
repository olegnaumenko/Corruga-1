//
//  PageViewControllerDelegate.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class PageViewCoordinator
{
    fileprivate let pageViewDataSource:PageViewDatasource
    fileprivate let pageViewController:UIPageViewController
    private let pageViewControllerObserver = PageViewControllerObserver()
    private var storyboard = UIStoryboard.init(name: Appearance.kMainStoryboardName, bundle: nil)
    
    init(pageViewController:UIPageViewController,
         dictModel:DictModel,
         currentIndex:Int = 0,
         imageProvider:ImageProvider? = nil) {
        
        let dataSource = PageViewDatasource(dictModel: dictModel,
                                            storyboard:self.storyboard,
                                            imageProvider: imageProvider,
                                            currentIndex:currentIndex)
        pageViewController.dataSource = dataSource
        
        self.pageViewController = pageViewController
        self.pageViewDataSource = dataSource
        
        pageViewController.delegate = self.pageViewControllerObserver
        self.pageViewControllerObserver.delegate = self
    }
    
    deinit {
        print("Page Coordinator deinit")
    }
    
    fileprivate func configure(detailViewController:DetailViewController, atIndex:Int) {
        detailViewController.onPhotoTapped = { [unowned self] imagePath in
            self.imageTappedInDetailView(imagePath: imagePath)
        }
        detailViewController.onViewDidAppear = {
            if let entry = self.pageViewDataSource.dictModel.searchResults?[atIndex] {
                UserActivityFabric.create(view: detailViewController.view, title: entry.stringValue, id: entry.termID, lang: entry.languageID)
            }
        }
    }

    private func imageTappedInDetailView(imagePath:String) {
        if let photoVC = self.storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
            photoVC.photoViewModel = PhotoViewModel(imagePath: imagePath, description: "Please visit company website")
            self.pageViewController.present(photoVC, animated: true)
        }
    }
}

extension PageViewCoordinator: PageViewControllerObserverDelegate {
    func willTransitionTo(viewController: UIViewController) {
        if let dvc = viewController as? DetailViewController, let index = self.pageViewController.viewControllers?.firstIndex(of: dvc) {
            self.configure(detailViewController: dvc, atIndex: index)
        }
    }
}

extension PageViewCoordinator: CoordinatorProtocol {
    func start() {
        let index = self.pageViewDataSource.currentIndex
        if let dvc = self.pageViewDataSource.viewControllerForIndex(index: index) {
            self.pageViewController.setViewControllers([dvc],
                                                       direction: .forward,
                                                       animated: false,
                                                       completion: nil)
            self.configure(detailViewController: dvc, atIndex: index)
        }
    }
}
