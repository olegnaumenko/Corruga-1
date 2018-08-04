//
//  DetailViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var pronounceButton: UIButton!
    
    var speechSynth:AVSpeechSynthesizer?
    
    var viewModel = DetailViewModel(term:"", translation:"", langID:"en-US", entry: TranslationEntity()) {
        didSet {
            self.update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }
    
    private func update() {
        self.termLabel?.text = viewModel.term
        self.translationLabel?.text = viewModel.translation
    }
    
    @IBAction func onPronounceButton(_ sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.async {
            self.pronounce()
        }
    }
    
    private func pronounce()
    {
        let asession = AVAudioSession.sharedInstance()
        
        do {
            try asession.setCategory(AVAudioSessionCategoryPlayback,
                                     mode:AVAudioSessionModeDefault,
                                     options:[.defaultToSpeaker, .duckOthers])
            try asession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            print("could not configure avsession: \(error.localizedDescription)")
        }
        
        let utt = AVSpeechUtterance(string: self.translationLabel.text!)
        utt.voice = AVSpeechSynthesisVoice(language: self.viewModel.langID)
        self.speechSynth = AVSpeechSynthesizer.init()
        self.speechSynth?.delegate = self
        self.speechSynth?.speak(utt)
    }
    
    fileprivate func speechSynthFinished() {
        self.pronounceButton.isEnabled = true
        
        let asession = AVAudioSession.sharedInstance()
        try? asession.setCategory(AVAudioSessionCategoryAmbient)
        try? asession.setActive(false)
    }
    
    fileprivate func speechSynthStarted() {
//        self.pronounceButton.isEnabled = false
    }
}

extension DetailViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.speechSynthStarted()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.speechSynthFinished()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speechSynthFinished()
    }
    
}
