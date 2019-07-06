//
//  ColorTextfileDelegate.swift
//  TextfieldDelegateApp
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation
import UIKit

class ColorTextFieldDelegate: NSObject, UITextFieldDelegate{
    var translations = [String : UIColor]()
    
    override init() {
        super.init()
        translations["blue"] = UIColor.blue
        translations["green"] = UIColor.green
        translations["red"] = UIColor.red
        translations["brown"] = UIColor.brown
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var colorsInTheText = [UIColor]()
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        for(key, color) in translations{
            if newText.range(of: key, options: .caseInsensitive).location != NSNotFound{
                colorsInTheText.append(color)
            }
        }
        
        if colorsInTheText.count > 0{
            textField.textColor = self.blendColorArray(colorsInTheText)
        }
        
         return true
        
    }
    
    /**
     * accepts an array of colors, and return a blend of all the elements
     */
    
    func blendColorArray(_ colors: [UIColor]) -> UIColor {
        var colorComponents: [CGFloat] = [CGFloat](repeating: 0.0, count: 4)
        
        for color in colors {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            colorComponents[0] += red
            colorComponents[1] += green
            colorComponents[2] += blue
            colorComponents[3] += alpha
        }
        
        for i in 0...colorComponents.count - 1 {
            colorComponents[i] /= CGFloat(colors.count)
        }
        
        return UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3])
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
