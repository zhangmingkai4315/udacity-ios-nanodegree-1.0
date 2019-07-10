//
//  MyOAViewController.swift
//  ExampleMyOA
//
//  Created by mingkai on 2019/7/7.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class MyOAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Again", style: .plain, target: self, action: #selector(startOver))
        // Do any additional setup after loading the view.
    }
    
    @objc func startOver(){
        navigationController?.popToRootViewController(animated: true)
    }
    deinit {
        print("view controller deallocated")
    }

}
