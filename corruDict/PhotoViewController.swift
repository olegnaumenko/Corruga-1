//
//  SecondViewController.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet private var photoImageView:UIImageView!
    @IBOutlet private var titleLabel:UILabel!
    @IBOutlet private var descriptionLabel:UILabel!
    @IBOutlet private var closeButton:UIButton!
    
    var photoViewModel:PhotoViewModel = PhotoViewModel(image:nil, title:"", description:"") {
        didSet {
            if (self.view != nil) {
                photoImageView.image = photoViewModel.photoImage
                titleLabel.text = photoViewModel.photoTitle
                descriptionLabel.text = photoViewModel.photoDescription
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gr = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(sender:)))
        gr.direction = .down
        self.view.addGestureRecognizer(gr)
    }
    
    func onSwipe(sender:UIGestureRecognizer) {
        if (sender.state == .recognized) {
            self.close()
        }
    }
    
    @IBAction func onCloseButton(sender:UIButton) {
        self.close()
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }


}
