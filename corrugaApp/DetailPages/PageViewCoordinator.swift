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
        
        let dictModel = pageViewDataSource.dictModel
        pageViewController.title = "translation-view-title".n10 + ": \(dictModel.currentShortLanguageDirection)"
        pageViewController.delegate = self.pageViewControllerObserver
        self.pageViewControllerObserver.delegate = self
    }
    
//    deinit {
//        print("Page Coordinator deinit")
//    }
    
    fileprivate func configure(detailViewController:DetailViewController) {
        detailViewController.onPhotoTapped = { [unowned self] imagePath in
            self.imageTappedInDetailView(imagePath: imagePath)
        }
    }

    private func imageTappedInDetailView(imagePath:String) {
        
        let photoVC = UIStoryboard.photoViewController()
        photoVC.photoViewModel = PhotoViewModel(imagePath: imagePath, description: "image-zoom-view-visit-company-website".n10)
        photoVC.modalPresentationStyle = .pageSheet
        self.pageViewController.present(photoVC, animated: true)

        AppAnalytics.shared.logEvent(name: "open_image", params: nil)
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
