//
//  DiceViewController.swift
//  presentvc
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class DiceViewController: UIViewController {
    
    var value1 : String?
    var value2 : String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let v = value1{
            dice1.text = v
        }
        if let v = value2{
            dice2.text = v
        }
    }
    
    
    @IBOutlet weak var dice1: UILabel!
    @IBOutlet weak var dice2: UILabel!
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
