//
//  DetailViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    private lazy var speechSynth = SpeechSynth()
    private lazy var tapGestureReco = UITapGestureRecognizer(target: self, action: #selector(self.onPhotoTap(sender:)))
    
    var onPhotoTapped:(String)->() = {imagePath in}
    var onViewDidAppear:()->() = {}

    
    var viewModel = DetailViewModel(term:"", translation:"",
                                    langID:"en-US", entry: TranslationEntity(), imagePath:"") {
        didSet {
            self.update()
        }
    }
    
    deinit {
        print("Detail VC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pronounceButton.backgroundColor = Appearance.buttonBackgroundColor()
        self.photoLabel.textColor = Appearance.secondaryTextColor()
        
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.addGestureRecognizer(self.tapGestureReco)
        
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
        
        if viewModel.imagePath != "" {
            self.photoImageView?.image = UIImage(contentsOfFile: viewModel.imagePath)
            self.photoImageView?.sizeToFit()
        }
    }
    
    @IBAction func onPronounceButton(_ sender: UIButton) {
        sender.isEnabled = false
        let text = viewModel.translation
        let langID = viewModel.langID
        DispatchQueue.main.async {
            self.speechSynth.pronounce(text: text, langID: langID) {
                sender.isEnabled = true
            }
        }
    }
}

