//
//  FirstViewController.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet private var tableView:UITableView?
    @IBOutlet var searchTextField:UITextField?
    @IBOutlet private var voiceButton:UIButton!
    @IBOutlet weak var langSwapButton: UIButton?
    @IBOutlet weak var headerView:UIView!
    
    var searchBlock:((String)->())?
    var voiceStartBlock:(()->())?
    var languageSwapBlock:(()->())?
    var selectPrepareBlock:((IndexPath, UIViewController)->())?
    var inputModeChangeBlock:((String)->())?
    
    var scrollManager:ScrollManager? {
        didSet {
            scrollManager?.delegate = self
        }
    }
    
    var currentSearchTerm:String? {
        get {
            return self.searchTextField != nil ? self.searchTextField?.text : nil
        }
    }
    
    var searchTerm:String? {
        didSet {
            self.searchTextField?.text = searchTerm
            self.searchTextFieldTerm()
        }
    }
    
    var dataSource:SearchTableDataSource? {
        didSet {
            if let tv = self.tableView {
                tv.dataSource = dataSource
            }
        }
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.navigationController?.navigationBar.barTintColor
        
        self.searchTextField?.delegate = self
        self.searchTextField?.addTarget(self, action: #selector(ListViewController.textFieldDidChange), for: .editingChanged)
        self.tableView?.dataSource = self.dataSource

        //add mic in search field:
        /*
         self.addSearchMicRightButton()
        */
        
        if let tv = self.tableView, let rs = self.searchTextField {
            self.scrollManager = ScrollManager(tableView: tv, responder: rs)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.inputModeDidChange), name: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil)
    }
    
    @objc private func inputModeDidChange(n:Notification)
    {
        if let lang = self.searchTextField?.textInputMode?.primaryLanguage,
            let count = self.searchTextField?.text?.count,
            count == 0 {
            
            self.inputModeChangeBlock?(lang)
        }
    }
    
    private func addSearchMicRightButton()
    {
        let micButton = UIButton(type: .custom)
        micButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        micButton.setImage(UIImage(named: "Mic"), for: .normal)
        micButton.backgroundColor = UIColor.lightGray
        micButton.layer.cornerRadius = 3
        self.searchTextField?.rightView = micButton
        self.searchTextField?.rightViewMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView?.selectRow(at: nil, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    //MARK: - Public
    
    func refresh() {
        self.tableView?.reloadData()
    }
    
    func setLanguagesLabel(label:String){
        self.langSwapButton?.setTitle(label, for: .normal)
    }

    func voiceSessionEnded() {
        self.voiceButton.isEnabled = true
    }
    
    private func searchTextFieldTerm() {
        self.searchBlock?(self.searchTextField?.text?.lowercased() ?? "")
    }
    
    
    // MARK: - Actions
    
    @IBAction func onVoiceButton(sender:UIButton) {
        sender.isEnabled = false
        self.searchTextField?.text = nil
        self.searchTextField?.resignFirstResponder()
        
        self.voiceStartBlock?()
    }
    
    @objc private func textFieldDidChange(sender:UITextField) {
        self.searchTextFieldTerm()
    }

    @IBAction func onLabguageSwapButton(_ sender: UIButton) {
        self.languageSwapBlock?()
    }
    
 
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = self.tableView?.indexPath(for: cell) {
                self.selectPrepareBlock?(indexPath, segue.destination)
            }
        }
     }
}

// MARK: - ListScrollManagerDelegate

extension ListViewController : ScrollManagerDelegate {
    
    func scrollManagerTableviewCellTapped() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Text Field Delegate

extension ListViewController : UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
