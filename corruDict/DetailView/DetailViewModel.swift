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
    
    var translation:String?
    var termTranscription:String? {
        get {
            return self.transcription(entry.transcription)
        }
    }
    
    var translationTranscription:String? {
        get {
            return self.transcription(translationEntry?.transcription)
        }
    }
    
    var langID = "en-US"
    var entry:TranslationEntryModel
    var translationEntry:TranslationEntryModel?
    
    private (set) var imagePath:String = ""
    
    init(entry:TranslationEntryModel, translation:TranslationEntryModel?, imagePath:String?) {
        self.translation = translation?.value ?? "<no translation>"
        self.imagePath = imagePath ?? ""
        self.translationEntry = translation
        self.entry = entry
    }
    
    private func transcription(_ from:String?) -> String? {
        if let value = from, value.count > 0 {
            return String.init(format: "[ %@ ]", entry.transcription)
        }
        return nil
    }
    
    
    func imageName() -> String {
        let nsstring = NSString(string: imagePath).lastPathComponent.replacingOccurrences(of: ".jpg", with: "")
        return nsstring
    }
}
