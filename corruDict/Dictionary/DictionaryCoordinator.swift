//
//  Coordinator.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class DictionaryCoordinator: BaseFeatureCoordinator {
    
//    private var dictModel:DictModel
    private var imageProvider = ImageProvider()
//    private lazy var speechManager = SpeechManager()
    
    private let navigationController:UINavigationController
    private let viewController:DictionaryViewController
    
    fileprivate var pageViewCoordinator: CoordinatorProtocol?
    
    init(navController:UINavigationController) {
        self.navigationController = navController
        
        self.viewController = ListViewControllerFinder(navController: navController).listViewController
//        self.dictModel = DictModel(fromID: Settings.s.fromLangID, toID: Settings.s.toLangID)
        self.viewController.viewModel = DictionaryViewModel(dictModel: DictModel.shared)
        
        super.init()
        
        self.start(viewController: viewController)
    }
    
    func translate(term:String) {
        self.viewController.viewModel.search(term: term)
    }
    
    override func start(viewController: BaseFeatureViewController) {
        super.start(viewController: viewController)
        self.configureListViewController(vc: self.viewController)
    }
    
    private func configureListViewController(vc:DictionaryViewController) {
        vc.onTermSelectedBlock = { [unowned self] indexPath, destinationVC in
            self.preparePageViewCoordinator(indexPath: indexPath, viewController: destinationVC)
        }
    }
    
    
    private func preparePageViewCoordinator(indexPath:IndexPath, viewController:UIViewController) {
        if let pvc = viewController as? PageViewController {
            self.pageViewCoordinator = PageViewCoordinator(pageViewController: pvc,
                                                           dictModel: DictModel.shared,
                                                           currentIndex: indexPath.row,
                                                           imageProvider:self.imageProvider)
            self.pageViewCoordinator?.start()
            AppAnalytics.shared.logEvent(name: "open_dict_page", params: nil)
        }
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



//    private func startVoiceSession() {
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
//    }
