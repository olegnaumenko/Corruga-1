//
//  Coordinator.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class DictionaryCoordinator: BaseFeatureCoordinator {
    
    private var dictModel:DictModel
    private var imageProvider = ImageProvider()
//    private lazy var speechManager = SpeechManager()
    
    private let navigationController:UINavigationController
    private let viewController:ListViewController
    
    fileprivate var pageViewCoordinator: CoordinatorProtocol?
    
    init(navController:UINavigationController) {
        self.navigationController = navController
        self.viewController = ListViewControllerFinder(navController: navController).listViewController
        self.dictModel = DictModel(fromID: Settings.s.fromLangID, toID: Settings.s.toLangID)
        super.init()
        
        self.start(viewController: viewController)
//        navController.delegate = self
        self.bindToDictModel(dict: self.dictModel)
        self.configureListViewController(vc: self.viewController)
    }
    
    func translate(term:String) {
        self.search(term: term);
        self.viewController.searchTerm = term
    }
    
    private func bindToDictModel(dict:DictModel) {
        dict.onDictResultsChanged = { [unowned self] in
            self.viewController.refresh()
        }
        dict.onDictLanguagesSwapped = { [unowned self] in
            self.viewController.updateLanguagesLabel()
        }
    }
    
    private func configureListViewController(vc:ListViewController) {
        vc.dataSource = ListTableDataSource(dictModel: self.dictModel)
        vc.searchBlock = { [unowned self] in
            self.search(term: $0)
        }
//        vc.voiceStartBlock = { [unowned self] in
//            self.startVoiceSession()
//        }
        vc.selectPrepareBlock = { [unowned self] indexPath, destinationVC in
            self.preparePageViewCoordinator(indexPath: indexPath, viewController: destinationVC)
        }
        vc.languageSwapBlock = { [unowned self] in
            self.swapLanguages(reSearch: false)
        }
        vc.inputModeChangeBlock = { [unowned self] locale, text in
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
        } else {
            self.clearSearch()
        }
        AppAnalytics.shared.logEvent(name: "swap_lang", params: ["to_lang" : self.dictModel.toLanguageID])
    }
    
    private func inputModeChange(locale:String, text:String) {
        if SwapLangViewModel(dict: self.dictModel, text: text, langID: locale).shouldSwap {
            self.swapLanguages(reSearch: false)
        }
    }
    
    private func preparePageViewCoordinator(indexPath:IndexPath, viewController:UIViewController) {
        if let pvc = viewController as? PageViewController {
            self.pageViewCoordinator = PageViewCoordinator(pageViewController: pvc,
                                                           dictModel: self.dictModel,
                                                           currentIndex: indexPath.row,
                                                           imageProvider:self.imageProvider)
            self.pageViewCoordinator?.start()
            AppAnalytics.shared.logEvent(name: "open_dict_page", params: nil)
        }
    }
    
    private func startVoiceSession() {
//        let localeID = self.dictModel.fromLanguageID.replacingOccurrences(of: "_", with: "-")
//        self.speechManager.startVoiceSession(localeID: localeID, duration: 10, result: { [unowned self] (result, final) in
//            print(result)
//            print(final)
//            self.viewController.searchTerm = result
//        }, completion: { [unowned self] (error) in
//            if (error != nil) {
//                print("ERROR:")
//                print(error!)
//            } else {
//                print("COMPLETION")
//            }
//            self.viewController.voiceSessionEnded()
//        })
    }
    
    private func search(term:String) {
        let oldCount = self.dictModel.currentSearchTerm.count
        
        self.dictModel.currentSearchTerm = term
        Settings.s.searchTerm = term
        
        if (oldCount > self.dictModel.currentSearchTerm.count) {
            self.viewController.scrollToTop()
        }
    }
    
    private func clearSearch() {
        let term = ""
        self.dictModel.currentSearchTerm = term
        Settings.s.searchTerm = term
        self.viewController.searchTerm = term
        self.viewController.scrollToTop()
    }
    
    
// MARK: App lifecycle
    
    func appDidFinishLaunching(_ application: UIApplication) {
    }
    
    func appWillResignActive(_ application: UIApplication) {
    }
    
    func appDidEnterBackground(_ application: UIApplication) {
    }
    
    func appWillEnterForeground(_ application: UIApplication) {
    }
}

extension DictionaryCoordinator:UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        guard
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController) else {
                return
        }

        if (fromViewController is PageViewController) {
            self.pageViewCoordinator = nil
        }
    }
}
