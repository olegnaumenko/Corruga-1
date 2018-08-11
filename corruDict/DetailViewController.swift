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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    private lazy var tapGestureReco = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoTap(sender:)))
    
    var onPhotoTapped:(UIImage?)->() = {image in}
    
    var speechSynth:AVSpeechSynthesizer?
    
    var viewModel = DetailViewModel(term:"", translation:"", langID:"en-US", entry: TranslationEntity(), imagePath:"") {
        didSet {
            self.update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pronounceButton.backgroundColor = WSColourScheme.sharedInstance.getColour(colour: WSCSColourTwo)
        self.photoLabel.textColor = WSColourScheme.sharedInstance.getColour(colour: WSCSColourTwo)
        
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.addGestureRecognizer(self.tapGestureReco)
        
        self.update()
    }
    
    @objc func onPhotoTap(sender: UITapGestureRecognizer)
    {
        if (sender.state == .recognized) {
            self.onPhotoTapped(self.photoImageView.image)
        }
    }
    
    private func update() {
        self.termLabel?.text = viewModel.term
        self.translationLabel?.text = viewModel.translation
        self.photoLabel?.text = viewModel.imageName()
        
        if viewModel.imagePath != "" {
            self.photoImageView?.image = UIImage(contentsOfFile: viewModel.imagePath)
            self.photoImageView?.sizeToFit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
