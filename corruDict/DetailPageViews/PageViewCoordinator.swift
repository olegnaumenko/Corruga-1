//
//  PageViewControllerDelegate.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class PageViewCoordinator
{
    let pageViewDataSource:PageViewDatasource
    
    init(dataSource:PageViewDatasource) {
        self.pageViewDataSource = dataSource
        
        dataSource.didCreateDetailViewController =  { dvc in
            self.configure(detailViewController: dvc)
        }
    }
    
    func configure(detailViewController:DetailViewController) {
        detailViewController.onPhotoTapped = { imagePath in
            self.imageTappedInDetailView(imagePath: imagePath, callerVC:detailViewController)
        }
    }

    func imageTappedInDetailView(imagePath:String, callerVC:UIViewController)
    {
        if let photoVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        {
            photoVC.photoViewModel = PhotoViewModel(imagePath: imagePath, description: "Please visit company website")
            callerVC.present(photoVC, animated: true) {
                
            }
        }
    }
}
