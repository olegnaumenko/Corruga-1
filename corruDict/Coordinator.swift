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
    
    private var dictModel:DictModel
    private var imageProvider = ImageProvider()
    private lazy var speechManager = SpeechManager()
    
    var navigationController:UINavigationController? { didSet {
            if let nc = navigationController {
                self.viewController = ListViewControllerFinder(navController: nc).listViewController
            } else { fatalError() }
        }
    }
    
    private var viewController:ListViewController? { didSet {
            if let vc = viewController {
                self.configureListViewController(vc: vc)
            } else { fatalError() }
        }
    }
    
    init() {
        self.dictModel = DictModel(fromID: Settings.s.fromLangID, toID: Settings.s.toLangID)
        self.configureDictModel(dict: self.dictModel)
    }
    
    private func configureDictModel(dict:DictModel) {
        dict.onDictResultsChanged = {
            self.viewController?.refresh()
        }
        dict.onDictLanguagesSwapped = {
            self.viewController?.setLanguagesLabel()
        }
    }
    
    private func configureListViewController(vc:ListViewController) {
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
        let searchTerm = Settings.s.searchTerm
        vc.searchTerm = searchTerm
        self.search(term: searchTerm)
    }
    
    private func swapLanguages(reSearch:Bool) {
        self.dictModel.swapLanguages()
        Settings.s.setLanguages(from: self.dictModel.fromLanguageID, to: self.dictModel.toLanguageID)
        if (reSearch) {
            self.search(term: self.dictModel.currentSearchTerm)
        }
    }
    
    private func inputModeChange(locale:String, text:String) {
        if SwapLangViewModel(dict: self.dictModel, text: text, langID: locale).shouldSwap {
            self.swapLanguages(reSearch: false)
        }
    }
    
    private func prepareDetailViewController(indexPath:IndexPath, viewController:UIViewController) {
        if let entry = self.dictModel.searchResults?[indexPath.row] {
            
            if let dvc = viewController as? DetailViewController
            {
                let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
                dvc.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry, imagePath:"")
            }
            else if let pvc = viewController as? PageViewController {
                self.configurePageViewController(pvc: pvc, indexPath: indexPath)
            }
        }
    }
    
    private func configurePageViewController(pvc:PageViewController, indexPath:IndexPath) {
        let dataSource = PageViewDatasource(dictModel: self.dictModel)
        let coordinator = PageViewCoordinator(dataSource: dataSource)
        dataSource.imageProvider = self.imageProvider
        dataSource.currentIndex = indexPath.row
        pvc.pageViewCoordinator = coordinator
    }
    
    private func startVoiceSession() {
        let localeID = self.dictModel.fromLanguageID.replacingOccurrences(of: "_", with: "-")
        self.speechManager.startVoiceSession(localeID: localeID, duration: 10, result: { (result, final) in
            print(result)
            print(final)
            self.viewController?.searchTerm = result
        }, completion: { (error) in
            if (error != nil) {
                print("ERROR:")
                print(error!)
            } else {
                print("COMPLETION")
            }
            self.viewController?.voiceSessionEnded()
        })
    }
    
    private func search(term:String) {
        self.dictModel.currentSearchTerm = term
        Settings.s.searchTerm = term
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
