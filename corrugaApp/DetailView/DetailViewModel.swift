//
//  DetailViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct DetailViewModel {
    
    var term:String {
        get {
            return entry.value
        }
    }
    
    var translation:String? {
        get {
            return translationEntry?.value ?? "<no translation>"
        }
    }
    var termTranscription:String? {
        get {
            return self.transcription(entry)
        }
    }
    
    var translationTranscription:String? {
        get {
            return self.transcription(translationEntry)
        }
    }
    
    var langID = "en-US"
    var entry:TranslationEntryModel
    var translationEntry:TranslationEntryModel?
    
    private (set) var imagePath:String = ""
    
    init(entry:TranslationEntryModel, translation:TranslationEntryModel?, imagePath:String?, langID:String) {
        self.imagePath = imagePath ?? ""
        self.translationEntry = translation
        self.langID = langID
        self.entry = entry
    }
    
    private func transcription(_ fromEntry:TranslationEntryModel?) -> String? {
        if let transc = fromEntry?.transcription, transc.count > 0 {
            return String.init(format: "[ %@ ]", transc)
        }
        return nil
    }
    
    
    func imageName() -> String {
        let nsstring = NSString(string: imagePath).lastPathComponent.replacingOccurrences(of: ".jpg", with: "")
        return nsstring
    }
}
