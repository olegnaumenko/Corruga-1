//
//  SpeechSynth.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSynth:NSObject {
    
    //TODO: make SpeechSynth one entity on top model level?
    //to avoid leaks in AVSpeechSynthesizer
    
    private var onFinished = {}
    private var speechSynthesizer:AVSpeechSynthesizer?
    private var audioSession = AudioSession()
    
    override init() {
        super.init()
    }
    
    deinit {
        print("Speech Synth deinit")
    }
    
    func pronounce(text:String, langID:String, completion:@escaping ()->()) {
        self.onFinished = completion
        self.speak(text: text, langID: langID)
    }
    
    private func speak(text:String, langID:String) {
        self.audioSession.activate()
        let utt = AVSpeechUtterance(string: text)
        utt.voice = AVSpeechSynthesisVoice(language: langID)
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechSynthesizer?.delegate = self
        self.speechSynthesizer?.speak(utt)
    }
    
    fileprivate func speechSynthFinished() {
        self.audioSession.deactivate()
        self.speechSynthesizer = nil
        self.onFinished()
    }
    
//    fileprivate func speechSynthStarted() {
//    }
    
}

extension SpeechSynth:AVSpeechSynthesizerDelegate
{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//        self.speechSynthStarted()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.speechSynthFinished()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speechSynthFinished()
    }
}
