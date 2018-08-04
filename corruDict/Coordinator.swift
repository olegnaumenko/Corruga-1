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
    
    var navigationController:UINavigationController? {
        didSet {
            if let cnt = navigationController?.viewControllers.count,
                cnt > 0, let vc = navigationController?.viewControllers[0] {
                self.viewController = vc as? ViewController
            }
        }
    }
    
    private var viewController:ViewController? {
        didSet {
            if let vc = viewController {
                vc.dataSource = DataSource(dictModel: self.dictModel)
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
                    self.dictModel.swapLanguages()
                    self.search(term: vc.currentSearchTerm)
                    vc.setLanguagesLabel(label: self.dictModel.languagesLabel())
                }
                vc.setLanguagesLabel(label: self.dictModel.languagesLabel())
                self.search(term: "")
            }
        }
    }
    
    init() {
        self.dictModel = DictModel(fromID: "en_US", toID: "ru_RU")
        print(self.dictModel.fromStorage ?? "aaa")
    }
    
    private func prepareDetailViewController(indexPath:IndexPath, viewController:UIViewController) {
        if let entry = self.viewController?.dataSource?.displayedEntries?[indexPath.row] {
            if let dvc = viewController as? DetailViewController
            {
                let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
                dvc.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry)
            }
            else if let dvc = viewController as? PageViewController
            {
                let dataSource = PageViewControllerDatasource(dictModel: self.dictModel)
                dataSource.displayedEntries = self.viewController?.dataSource?.displayedEntries
                dataSource.currentIndex = indexPath.row
                dvc.pageDataSource = dataSource
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
    
    private func search(term:String?) {
        if let cnt = term?.count, cnt > 0 {
            self.viewController?.dataSource?.displayedEntries = self.dictModel.fromStorage.searchForTerms(term: term!)
        } else {
            self.viewController?.dataSource?.displayedEntries = self.dictModel.fromStorage.allTranslationEntities()
        }
        self.viewController?.refresh()
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
