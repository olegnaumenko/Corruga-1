//
//  PageViewControllerDatasource.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import RealmSwift

class PageViewDatasource: NSObject, UIPageViewControllerDataSource {

    var currentIndex:Int
    private var imageProvider:ImageProvider?
    private let storyboard:UIStoryboard
    let dictModel:DictModel
    
    init(dictModel:DictModel, storyboard:UIStoryboard, imageProvider:ImageProvider? = nil, currentIndex:Int = 0) {
        self.dictModel = dictModel
        self.currentIndex = currentIndex
        self.storyboard = storyboard
        self.imageProvider = imageProvider
        super.init()
    }
    
    deinit {
        print("Page Datasource deinit")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = self.dictModel.searchResults?.index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = self.dictModel.searchResults?.index(of: (viewController as! DetailViewController).viewModel.entry)
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
        if let detailViewController = self.storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            if let entry = self.dictModel.searchResults?[index] {
                let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
                
                detailViewController.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry, imagePath:self.imageProvider?.randomImageName() ?? "")
                
                currentIndex = index
                
                UserActivityFabric.create(view: detailViewController.view, title: entry.stringValue, id: entry.termID, lang: entry.languageID)
                
                return detailViewController
            }
        } else { fatalError() } 
        return nil
    }
    
}
