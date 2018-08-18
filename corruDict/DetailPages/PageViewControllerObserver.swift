//
//  PageViewControllerObserver.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

protocol PageViewControllerObserverDelegate:class
{
    func willTransitionTo(viewController:UIViewController)
}

class PageViewControllerObserver:NSObject
{
    weak var delegate:PageViewControllerObserverDelegate?
}

extension PageViewControllerObserver:UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.delegate?.willTransitionTo(viewController: pendingViewControllers[0])
    }
}
