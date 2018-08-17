//
//  Coordinator.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    var dictModel:DictModel
    
    var speechManager:SpeechManager?
    
    var imageProvider = ImageProvider()
    
    var navigationController:UINavigationController? {
        didSet {
            if let cnt = navigationController?.viewControllers.count,
                cnt > 0, let vc = navigationController?.viewControllers[0] {
                self.viewController = vc as? ListViewController
            }
        }
    }
    
    private var viewController:ListViewController? {
        didSet {
            if let vc = viewController {
                vc.dataSource = SearchTableDataSource(dictModel: self.dictModel)
                vc.searchBlock = {
                    self.search(term: $0)
                }
                vc.voiceStartBlock = {
                    self.startVoiceSession()
                }
                vc.selectPrepareBlock = { indexPath, destinationVC in
                    self.prepareDetailViewController(indexPath: indexPath, viewController: destinationVC)
                }
                vc.languageSwapBlock = {
                    self.swapLanguages(reSearch: true)
                }
                vc.inputModeChangeBlock = { locale, text in
                    self.inputModeChange(locale: locale, text: text)
                }
                self.search(term: self.dictModel.currentSearchTerm)
            }
        }
    }
    
    
    init() {
        self.dictModel = DictModel(fromID: "en_US", toID: "ru_RU")
        
        self.dictModel.dictResultsChanged = { results in
            self.viewController?.dataSource?.displayedEntries = results
            self.viewController?.refresh()
        }
        
        self.dictModel.dictLanguagesSwapped = {
            self.viewController?.setLanguagesLabel()
        }
    }
    
    
    private func swapLanguages(reSearch:Bool) {
        self.dictModel.swapLanguages()
        if (reSearch) {
            self.search(term: self.dictModel.currentSearchTerm)
        }
    }
    
    private func inputModeChange(locale:String, text:String) {
        if text.count == 0,
            let range = self.dictModel.toStorage.languageID.range(of: locale.substring(to: String.Index(encodedOffset: 1))) {
            let bound = range.lowerBound
            if bound == locale.startIndex {
                self.viewController?.languageSwapBlock?()
            }
        }
    }
    
    private func prepareDetailViewController(indexPath:IndexPath, viewController:UIViewController) {
        
        if let entry = self.viewController?.dataSource?.displayedEntries?[indexPath.row] {
            
            if let dvc = viewController as? DetailViewController
            {
                let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
                dvc.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry, imagePath:"")
            }
            else if let dvc = viewController as? PageViewController
            {
                let dataSource = PageViewDatasource(dictModel: self.dictModel)
                let coordinator = PageViewCoordinator(dataSource: dataSource)
                dataSource.imageProvider = self.imageProvider
                dataSource.displayedEntries = self.viewController?.dataSource?.displayedEntries
                dataSource.currentIndex = indexPath.row
                dvc.pageViewCoordinator = coordinator
            }
        }
    }
    
    private func startVoiceSession() {
        self.speechManager = SpeechManager()//localeID: "en-US")
        self.speechManager?.startVoiceSession(localeID: "en-US", duration: 5, result: { (result, final) in
            print(result)
            print(final)
            self.viewController?.searchTerm = result
        }, completion: { (error) in
            if (error != nil) {
                print("ERROR!")
            } else {
                print("COMPLETION")
            }
            self.viewController?.voiceSessionEnded()
        })
    }
    
    private func search(term:String) {
        self.dictModel.currentSearchTerm = term
    }
    
    
    
// MARK: App lifecycle
    
    func appDidFinishLaunching(_ application: UIApplication)
    {
    }
    
    func appWillResignActive(_ application: UIApplication)
    {
    }
    
    func appDidEnterBackground(_ application: UIApplication)
    {
    }
    
    func appWillEnterForeground(_ application: UIApplication)
    {
    }
}
