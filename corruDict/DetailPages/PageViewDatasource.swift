//
//  PageViewControllerDatasource.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
//import RealmSwift

class PageViewDatasource: NSObject, UIPageViewControllerDataSource {

    var currentIndex:Int
    private var imageProvider:ImageProvider?
//    private let storyboard:UIStoryboard
    let dictModel:DictModel
    
    init(dictModel:DictModel, storyboard:UIStoryboard?, imageProvider:ImageProvider? = nil, currentIndex:Int = 0) {
        self.dictModel = dictModel
        self.currentIndex = currentIndex
//        self.storyboard = storyboard
        self.imageProvider = imageProvider
        super.init()
    }
    
    deinit {
        print("Page Datasource deinit")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = self.dictModel.searchResults?.lastIndex(where: { (translationEntryModel) -> Bool in
            return translationEntryModel.id == (viewController as! DetailViewController).viewModel.entry.id
        }) //index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = self.dictModel.searchResults?.lastIndex(where: { (translationEntryModel) -> Bool in
            return translationEntryModel.id == (viewController as! DetailViewController).viewModel.entry.id
        }) //if let index = self.dictModel.searchResults?.index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index + 1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.dictModel.searchResults?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    
    
    func viewControllerForIndex(index:Int) -> DetailViewController?
    {
        if (index < 0 || index >= (self.dictModel.searchResults?.count)!) {
            return nil
        }
        
        let storyboard = UIStoryboard.init(name: Appearance.kMainStoryboardName, bundle: nil)
        
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            if let entry = self.dictModel.searchResults?[index] {
                
                self.dictModel.toLangModel.translation(withID: entry.id) { (translationEntryModel, error) in
                    
                    detailViewController.viewModel = DetailViewModel(entry: entry, translation: translationEntryModel, imagePath: self.imageProvider?.randomImageName())
                    
                    self.currentIndex = index
                }
                return detailViewController
            }
        } else { fatalError() } 
        return nil
    }
    
}
