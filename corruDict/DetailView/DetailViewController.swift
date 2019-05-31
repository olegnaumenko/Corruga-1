//
//  DetailViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var translationTranscriptionLabel: UILabel!
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    private lazy var speechSynth = SpeechSynth()
    private lazy var tapGestureReco = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoTap(sender:)))
    
    var onPhotoTapped:(String)->() = {imagePath in}
    var onViewDidAppear:()->() = {}

    var viewModel:DetailViewModel! 
    
//    deinit {
//        print("Detail VC deinit")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pronounceButton.backgroundColor = Appearance.appTintColor()
        self.pronounceButton.setImage(UIImage(named: "speaker")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.photoLabel.textColor = Appearance.secondaryTextColor()
        
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.addGestureRecognizer(self.tapGestureReco)
        
        self.termLabel.textColor = Appearance.middleTextColor()
        self.translationLabel.textColor = Appearance.largeTextColor()
        self.transcriptionLabel.textColor = Appearance.appTintColor()
        self.translationTranscriptionLabel.textColor = self.transcriptionLabel.textColor
        
        self.update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onViewDidAppear()
    }
    
    @objc func onPhotoTap(sender: UITapGestureRecognizer) {
        if (sender.state == .recognized) {
            self.onPhotoTapped(self.viewModel.imagePath)
        }
    }
    
    private func update() {
        self.termLabel?.text = viewModel.term
        self.translationLabel?.text = viewModel.translation
        self.photoLabel?.text = viewModel.imageName()
        self.transcriptionLabel?.text = viewModel.termTranscription
        self.translationTranscriptionLabel?.text = viewModel.translationTranscription
        
        if viewModel.imagePath != "" {
            self.photoImageView?.image = UIImage(contentsOfFile: viewModel.imagePath)
            self.photoImageView?.sizeToFit()
        }
    }
    
    @IBAction func onPronounceButton(_ sender: UIButton) {
        sender.isEnabled = false
        let langID = viewModel.langID
        if let text = viewModel.translation {
            DispatchQueue.main.async {
                self.speechSynth.pronounce(text: text, langID: langID) {
                    sender.isEnabled = true
                }
            }
        }
    }
}

