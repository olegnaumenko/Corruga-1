//
//  FirstViewController.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    @IBOutlet private var tableView:UITableView!
    @IBOutlet var searchTextField:UITextField!
    @IBOutlet private var voiceButton:UIButton!
    
    var searchBlock:((String)->())?
    var voiceStartBlock:(()->())?
    var selectPrepareBlock:((IndexPath, UIViewController)->())?
    
    var searchTerm:String? {
        didSet {
            self.searchTextField.text = searchTerm
            self.searchTextFieldTerm()
        }
    }
    
    var dataSource:DataSource? {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: .editingChanged)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.selectRow(at: nil, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }

    func voiceSessionEnded() {
        self.voiceButton.isEnabled = true
    }
    
    private func searchTextFieldTerm() {
        self.searchBlock?(self.searchTextField.text ?? "")
    }
    
    // MARK: - Actions
    
    @IBAction func onVoiceButton(sender:UIButton) {
        sender.isEnabled = false
        self.searchTextField.text = nil
        self.searchTextField.resignFirstResponder()
        
        self.voiceStartBlock?()
    }
    
    @objc private func textFieldDidChange(sender:UITextField) {
        self.searchTextFieldTerm()
    }
    
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let cnt = self.searchTextField.text?.count, cnt == 0 {
//            self.searchTextField.resignFirstResponder()
//        }
//    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.selectPrepareBlock?(indexPath, segue.destination)
            }
        }
     }
}

