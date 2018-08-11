//
//  PageViewControllerDelegate.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class PageViewControllerCoordinator
{
    let pageViewDataSource:PageViewControllerDatasource
    
    init(dataSource:PageViewControllerDatasource) {
        self.pageViewDataSource = dataSource
        
        dataSource.didCreateDetailViewController =  { dvc in
            self.configure(detailViewController: dvc)
        }
    }
    
    func configure(detailViewController:DetailViewController) {
        detailViewController.onPhotoTapped = { image in
            self.imageTappedInDetailView(image: image, callerVC:detailViewController)
        }
    }

    func imageTappedInDetailView(image:UIImage?, callerVC:UIViewController)
    {
        if let photoVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        {
            photoVC.photoViewModel = PhotoViewModel(image: image, title: "Image", description: "Super wooper description of the above super trooper image")
            callerVC.present(photoVC, animated: true) {
                
            }
        }
    }
}
