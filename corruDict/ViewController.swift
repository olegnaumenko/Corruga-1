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
    
    var dataSource:DataSource?
    {
        didSet {
            if let tv = self.tableView {
                tv.dataSource = dataSource
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: .editingChanged)
    }
    
    func refresh()
    {
        self.tableView.reloadData()
    }

    func voiceSessionEnded() {
        self.voiceButton.isEnabled = true
    }
    
    func searchTextFieldTerm()
    {
        self.searchBlock?(self.searchTextField.text ?? "")
    }
    
    @IBAction func onVoiceButton(sender:UIButton) {
        self.voiceStartBlock?()
        sender.isEnabled = false
        self.searchTextField.text = nil
    }
    
    func textFieldDidChange(sender:UITextField) {
        self.searchTextFieldTerm()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
//        if let entry = self.dataSource?.displayedEntries?[indexPath.row] {
//            self.searchTextField.text = entry.entry
//        }
    }
}

