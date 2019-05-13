//
//  FirstViewController.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class DictionaryViewController: BaseFeatureViewController {

    @IBOutlet private var tableView:UITableView!
    @IBOutlet var searchTextField:UITextField?
    @IBOutlet private var voiceButton:UIButton!
    @IBOutlet weak var langSwapButton: UIButton?
    @IBOutlet weak var fromLangButton: UIButton?
    @IBOutlet weak var toLangButton: UIButton?
    @IBOutlet weak var headerView:UIView!
    
    var onTermSelectedBlock:((IndexPath, UIViewController)->())?

    private let footerLabel = UILabel(frame: CGRect.init())
    private var keyboardObserver:KeyboardPositionObserver?
    private var floatingHeaderPresenter:FloatingHeaderPresenter?
    
    var scrollManager:ScrollManager? {
        didSet {
            scrollManager?.delegate = self
        }
    }
    
    var viewModel:DictionaryViewModel! {
        didSet {
            viewModel.onDidSearch = { [weak self] searchTerm, shoulldScrollToTop in
                if let the = self {
                    the.refreshList()
                    the.updateSearchFieldTerm()
                }
            }
            viewModel.onDidChangeLanguages = { [weak self] in
                if let the = self {
                    the.updateLanguagesIndicators()
//                    the.refreshList()
//                    DispatchQueue.main.async {
//
//                        the.scrollToTop()
//                    }
                }
            }
            self.dataSource = DictionaryTableDataSource(dictModel: viewModel.dictModel)
        }
    }
    
    private var dataSource:DictionaryTableDataSource! {
        didSet {
            if let tv = self.tableView {
                tv.dataSource = dataSource
            }
        }
    }
    
    // MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField?.delegate = self
        self.searchTextField?.text = viewModel.searchTerm
        self.searchTextField?.addTarget(self,
                                        action: #selector(DictionaryViewController.textFieldDidChange),
                                        for: .editingChanged)
        
        self.tableView.dataSource = self.dataSource
        self.tableView.tableFooterView = self.configureTableViewFooler(label: self.footerLabel)
        
        //colors
        let basicColor = Appearance.basicAppColor()
        self.view.backgroundColor = basicColor
        self.tableView.backgroundColor = Appearance.footerBackgroundColor()
        self.headerView.backgroundColor = Appearance.footerBackgroundColor()
            
        self.updateLanguagesIndicators()
        
        //add mic in search field:
        /*
         self.addSearchMicRightButton()
        */
        
        // listen for scrolling
        if let tView = self.tableView, let textField = self.searchTextField {
            self.scrollManager = ScrollManager(tableView: tView, responder: textField)
            self.floatingHeaderPresenter = FloatingHeaderPresenter(contentView: self.headerView, shownPositionY: 0.0)
            self.floatingHeaderPresenter?.scrollView = tView
        }
        
        //listen for keyboard position
//        self.keyboardObserver = KeyboardPositionObserver(onHeightChange: { [weak self] (height) in
//            if var contentInset = self?.tableView?.contentInset {
//                contentInset.bottom = CGFloat(height);
//                self?.tableView?.contentInset = contentInset
//            }
//        })
        
        var contentInset = self.tableView.contentInset 
        contentInset.top = self.headerView.frame.size.height
        self.tableView.contentInset = contentInset
        self.tableView.contentOffset = CGPoint(x: 0, y: -contentInset.top)
        
        //listen for text input mode change
        NotificationCenter.default.addObserver(self, selector: #selector(DictionaryViewController.inputModeDidChange), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
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
        self.footerLabel.text = self.viewModel.footerTotal()
    }
    
    private func updateSearchFieldTerm() {
        self.searchTextField?.text = viewModel.searchTerm
    }
    
    @objc private func inputModeDidChange(n:Notification) {
        if let lang = self.searchTextField?.textInputMode?.primaryLanguage,
            let text = self.searchTextField?.text {
            self.viewModel.inputModeChange(locale: lang, text: text)
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView?.selectRow(at: nil, animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    //MARK: - Public
    
    func refreshList() {
        //for proper scrolling to top afterwards:
        self.tableView?.dataSource = nil
        self.tableView?.reloadData()
        
        self.tableView?.dataSource = self.dataSource
        self.tableView?.reloadData()
        
        self.updateFooter()
        
        //need delay, otherwise results in wrong content offset (internally tableview lays out subviews):
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.scrollToTop()
        }
    }
    
    
    func scrollToTop(animated:Bool = false) {
        let contentInset = self.tableView!.contentInset
        self.tableView?.setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }
    
    func updateLanguagesIndicators() {
        self.fromLangButton?.setTitle(self.viewModel.fromLanguageLabel(), for: .normal)
        self.toLangButton?.setTitle(self.viewModel.toLanguageLabel(), for: .normal)
    }

    func voiceSessionEnded() {
        self.voiceButton.isEnabled = true
    }
    
    private func searchTextFieldTerm() {
        self.viewModel.search(term: self.searchTextField?.text?.lowercased() ?? "")
    }
    
    
    // MARK: - Actions
    
    @IBAction func onVoiceButton(sender:UIButton) {
        sender.isEnabled = false
        self.searchTextField?.text = nil
        self.searchTextField?.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(sender:UITextField) {
        self.searchTextFieldTerm()
    }

    @IBAction func onLanguageSwapButton(_ sender: UIButton) {
        self.viewModel.swapLanguages(reSearch: false)
    }
    
    @IBAction func onFromLangButton(_ sender: UIButton) {
        self.presentLangSelector(title: "Source language", sender: sender, currentLangId:self.viewModel.fromLangId) { (selectedLangId) in
            self.viewModel.setFromLangId(selectedLangId)
        }
    }
    
    @IBAction func onToLangButton(_ sender: UIButton) {
        self.presentLangSelector(title: "Destination language", sender: sender, currentLangId:self.viewModel.toLangId) { (selectedLangId) in
            self.viewModel.setToLangId(selectedLangId)
        }
    }
    
    private func presentLangSelector(title:String, sender:UIButton, currentLangId:String, completion:@escaping (String)->()) {
        if let index = Settings.s.availableLangIDs.firstIndex(of: currentLangId) {
            
            let langNames = Settings.s.availableLangIDs.compactMap { (langId) in
                return [LanguageModel.longName(langId: langId), LanguageModel.longNativeName(langId: langId)];
            }
            
            let selectvc = SelectViewController(values: langNames, currentIndex: UInt(index)) { (selectedIndex) in
                completion(Settings.s.availableLangIDs[selectedIndex])
                self.dismiss(animated: true, completion: nil)
                return true
            }
            
            let popoverVC = PopupViewController(title:  title, sender: sender, contentViewController: selectvc)
            popoverVC.preferredWidth = 200
            popoverVC.titleBarColor = Appearance.basicAppColor()
            popoverVC.popoverPresentationController?.permittedArrowDirections = .up
            self.present(popoverVC, animated: true, completion: nil)
        }
    }
 
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = self.tableView?.indexPath(for: cell) {
                self.onTermSelectedBlock?(indexPath, segue.destination)
            }
        }
     }
}

// MARK: - ListScrollManagerDelegate

extension DictionaryViewController : ScrollManagerDelegate {
    
    func scrollManagerTableviewCellTapped() {
    }
}

// MARK: - Text Field Delegate

extension DictionaryViewController : UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
