//
//  EmojiTextFieldDelegate.swift
//  TextfieldDelegateApp
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation
import UIKit

class EmojiTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    var translations = [String : String]()
    
    override init() {
        super.init()
        translations["heart"] = "♥️"
        translations["fish"] = "🐟"
        translations["bird"] = "🦅"
        translations["bear"] = "🍺"
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var replacedAnEmoji = false
        var emojiStringRange: NSRange
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        for(emojiString, emoji) in translations{
            repeat{
                emojiStringRange = newText.range(of: emojiString, options: .caseInsensitive)
                if emojiStringRange.location != NSNotFound{
                    newText = (newText.replacingCharacters(in: emojiStringRange, with: emoji)) as NSString
                    replacedAnEmoji = true
                }
            } while emojiStringRange.location != NSNotFound
        }
        if replacedAnEmoji {
            textField.text = newText as String
            return false
        }else{
            return true
        }
        
        
    }
    
    // 当用户开始输入的时候执行清除操作
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
