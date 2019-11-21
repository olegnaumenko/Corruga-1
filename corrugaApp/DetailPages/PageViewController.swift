//
//  PageViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

//    deinit {
//        print("Page Controller deinit")
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = Appearance.backgroundAppColor()
//
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = Appearance.backgroundAppColor()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
