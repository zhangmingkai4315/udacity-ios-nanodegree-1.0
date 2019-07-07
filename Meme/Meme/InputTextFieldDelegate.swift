//
//  InputTextFieldDelegate.swift
//  Meme
//
//  Created by mingkai on 2019/7/7.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation

import UIKit

class InputTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
