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
//    private var storyboard = UIStoryboard.init(name: Appearance.kMainStoryboardName, bundle: nil)
    
    init(pageViewController:UIPageViewController,
         dictModel:DictModel,
         currentIndex:Int = 0,
         imageProvider:ImageProvider? = nil) {
        
        let dataSource = PageViewDatasource(dictModel: dictModel,
                                            storyboard:nil,
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
    
    fileprivate func configure(detailViewController:DetailViewController) {
        detailViewController.onPhotoTapped = { [unowned self] imagePath in
            self.imageTappedInDetailView(imagePath: imagePath)
        }
        detailViewController.onViewDidAppear = { [unowned self, unowned detailViewController] in

            if let index = self.pageViewController.viewControllers?.firstIndex(of: detailViewController),
               let entry = self.pageViewDataSource.dictModel.searchResults?[index] {

                UserActivityFabric.create(view: detailViewController.view, title: entry.stringValue, id: entry.termID, lang: entry.languageID)
            }
        }
    }

    private func imageTappedInDetailView(imagePath:String) {
        
        let storyboard = UIStoryboard.init(name: Appearance.kMainStoryboardName, bundle: nil)
        
        if let photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
            photoVC.photoViewModel = PhotoViewModel(imagePath: imagePath, description: "Please visit company website")
            photoVC.modalPresentationStyle = .formSheet
            self.pageViewController.present(photoVC, animated: true)
        }
        Analytics.shared.logEvent(name: "open_image", params: nil)
    }
}

extension PageViewCoordinator: PageViewControllerObserverDelegate {
    func willTransitionTo(viewController: UIViewController) {
        if let dvc = viewController as? DetailViewController {
            self.configure(detailViewController: dvc)
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
            self.configure(detailViewController: dvc)
        }
    }
}
