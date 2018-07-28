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
    
    var dictModel:DictModel!
    var dictModels:[DictModel] = []
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
                vc.dataSource = DataSource(storage: self.dictModel.storage)
                vc.searchBlock = {
                    self.search(term: $0)
                }
                vc.voiceStartBlock = {
                    self.startVoiceSession()
                }
                vc.selectPrepareBlock = { indexPath, destinationVC in
                    self.prepareDetailViewController(indexPath: indexPath, viewController: destinationVC)
                }
            }
        }
    }
    
    init() {
        self.dictModel = DictModel(locale: "en-ru")
        print(self.dictModel.storage ?? "aaa")
    }
    
    private func prepareDetailViewController(indexPath:IndexPath, viewController:UIViewController) {
        if let dvc = viewController as? DetailViewController,
            let entry = self.viewController?.dataSource?.displayedEntries?[indexPath.row] {
            dvc.viewModel = DetailViewModel(term:entry.entry, translation:entry.translation)
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
        if term.count > 0 {
            self.viewController?.dataSource?.displayedEntries = self.dictModel.storage.searchForTerms(term: term)
        } else {
            self.viewController?.dataSource?.displayedEntries = self.dictModel.storage.allEntries()
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
