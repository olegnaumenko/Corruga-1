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
    var inputModeChangeBlock:((String, String)->())?

    private let footerLabel = UILabel(frame: CGRect.init())
    private var keyboardObserver:KeyboardPositionObserver?
    
    var scrollManager:ScrollManager? {
        didSet {
            scrollManager?.delegate = self
        }
    }
    
    var searchTerm:String? {
        didSet {
            self.searchTextField?.text = searchTerm
        }
    }
    
    var dataSource:ListTableDataSource? {
        didSet {
            if let tv = self.tableView {
                tv.dataSource = dataSource
            }
        }
    }
    
    // MARK: - Init
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField?.delegate = self
        self.searchTextField?.text = searchTerm
        self.searchTextField?.addTarget(self, action: #selector(ListViewController.textFieldDidChange), for: .editingChanged)
        
        self.tableView?.dataSource = self.dataSource
        self.tableView?.tableFooterView = self.configureTableViewFooler(label: self.footerLabel)
        
        //colors
        self.tableView?.backgroundColor = Appearance.basicAppColor()
        self.view.backgroundColor = Appearance.basicAppColor()
        
        self.updateLanguagesLabel()
        
        //add mic in search field:
        /*
         self.addSearchMicRightButton()
        */
        
        // listen for scrolling
        if let tv = self.tableView, let rs = self.searchTextField {
            self.scrollManager = ScrollManager(tableView: tv, responder: rs)
        }
        //listen for keyboard position
        self.keyboardObserver = KeyboardPositionObserver(onHeightChange: {[weak self] (height) in
            if var contentInset = self?.tableView?.contentInset {
                contentInset.bottom = CGFloat(height);
                self?.tableView?.contentInset = contentInset
            }
        })
        //listen for text input mode change
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.inputModeDidChange), name: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil)
    }
    
    private func configureTableViewFooler(label:UILabel) -> (UIView) {
        var rect = CGRect.zero
        rect.size = CGSize(width: self.view.frame.size.width, height: 55)
        label.frame = rect
        label.textAlignment = .center
        label.backgroundColor = Appearance.footerBackgroundColor()
        label.textColor = Appearance.footerTextColor()
        label.font = Appearance.footerFont()
        return label
    }
    
    private func updateFooter() {
        self.footerLabel.text = self.dataSource?.footerTotal()
    }
    
    @objc private func inputModeDidChange(n:Notification) {
        if let lang = self.searchTextField?.textInputMode?.primaryLanguage,
            let text = self.searchTextField?.text {
            self.inputModeChangeBlock?(lang, text)
        }
    }
    
    private func addSearchMicRightButton() {
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
        self.updateFooter()
    }
    
    func scrollToTop(animated:Bool = false) {
        if let cnt = self.dataSource?.resultsCount(), cnt > 0 {
            self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
        }
    }
    
    func updateLanguagesLabel() {
        if let label = self.dataSource?.languagesLabel() {
            self.langSwapButton?.setTitle(label, for: .normal)
        }
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

    @IBAction func onLanguageSwapButton(_ sender: UIButton) {
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
