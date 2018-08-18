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

    private let dictModel:DictModel
//    var displayedEntries:Results<TranslationEntity>?
    var currentIndex:Int = 0
    
    var imageProvider:ImageProvider?
    
    var didCreateDetailViewController:((DetailViewController)->())?
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        super.init()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = self.dictModel.searchResults?.index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
        if let detailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            if let entry = self.dictModel.searchResults?[index], let imageProvider = self.imageProvider {
                let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
                
                detailViewController.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry, imagePath:imageProvider.randomImageName())
                
                currentIndex = index
                self.didCreateDetailViewController?(detailViewController)
                return detailViewController
            }
        }
        return nil
    }
    
}
