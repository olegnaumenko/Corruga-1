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
    var viewController:ViewController? {
        didSet {
            viewController?.dataSource = DataSource(storage: self.dictModel.storage)
            viewController?.searchBlock = {
                self.search(term: $0)
            }
            viewController?.voiceStartBlock = {
                self.startVoiceSession()
            }
        }
    }
    
    init() {
        self.dictModel = DictModel(locale: "en-ru")
        print(self.dictModel.storage ?? "aaa")
    }
    
    func startVoiceSession()
    {
        self.speechManager = SpeechManager(localeID: "en-US")
        self.speechManager?.startVoiceSession(localeID: "en-US", duration: 5, result: { (result, final) in
            print(result)
            print(final)
            self.viewController?.searchTextField.text = result
            self.viewController?.searchTextFieldTerm()
        }, completion: { (error) in
            if (error != nil) {
                print("ERROR!")
            } else {
                print("COMPLETION")
            }
            self.viewController?.voiceSessionEnded()
        })
    }
    
    func search(term:String)
    {
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
