//
//  ViewController.swift
//  TextfieldDelegateApp
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    let emojiDelegate = EmojiTextFieldDelegate()
    let colorDelegate = ColorTextFieldDelegate()
    let enableDelegate = EnableSwitchFieldDelegate()
    let cashDelegate = CashTextFieldDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        self.counterLabel.isHidden = true
        self.textField1.delegate = self
        
        self.textField2.delegate = emojiDelegate
        self.textField3.delegate = colorDelegate
        self.textField5.delegate = cashDelegate
        enableDelegate.enableEditSwitch = self.enableEditSwitch
        self.textField6.delegate = enableDelegate
        self.enableEditSwitch.setOn(false, animated: false)
    }
    
    @objc func hideKeyboard(){
       view.endEditing(true)
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var enableEditSwitch: UISwitch!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        self.counterLabel.isHidden = (newText.length == 0)
        self.counterLabel.text = String(newText.length)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

