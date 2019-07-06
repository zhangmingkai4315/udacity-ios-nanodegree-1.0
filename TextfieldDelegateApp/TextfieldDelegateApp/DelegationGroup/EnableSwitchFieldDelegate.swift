//
//  EnableSwitchFieldDelegate.swift
//  TextfieldDelegateApp
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation
import UIKit

class EnableSwitchFieldDelegate: NSObject, UITextFieldDelegate{
    
    var enableEditSwitch: UISwitch?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(self.enableEditSwitch?.isOn)
        if let editSwitch = self.enableEditSwitch{
            return editSwitch.isOn
        }
        return false
    }
    
}
