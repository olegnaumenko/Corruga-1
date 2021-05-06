//
//  DetailViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 7/28/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import AltHaneke


class DetailViewController: UIViewController {

    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var translationTranscriptionLabel: UILabel!
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var photoLabelTopConstraint: NSLayoutConstraint!
    
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
        self.pronounceButton.setImage(UIImage(named: "speaker")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.addGestureRecognizer(self.tapGestureReco)
        
        self.update()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pronounceButton.backgroundColor = Appearance.appTintLargeColor()
        self.photoLabel.textColor = Appearance.labelSecondaryColor()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onViewDidAppear()
    }
    
    private func adjustPhotoLabelConstraint() {
        
        if let image = photoImageView.image {
            let imageSize = image.size
            let imageRatio = imageSize.height / imageSize.width
            
            let viewSize = photoImageView.frame.size
            let height = viewSize.width * imageRatio
            let offset = viewSize.height - height
            
            photoLabelTopConstraint.constant = -offset/2 - 54;
        } else {
            dprint("SSS")
        }
    }
    
    private func frame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
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
            adjustPhotoLabelConstraint()
//            self.photoImageView?.sizeToFit()
//            self.photoImageView?.hnk_setImageFromFile(viewModel.imagePath, success:  { [weak self] img in
//                self?.photoImageView.image = img
//                self?.photoImageView.sizeToFit()
//                self?.adjustPhotoLabelConstraint()
//                self?.view.setNeedsLayout()
//                self?.view.setNeedsUpdateConstraints()
//            })
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

