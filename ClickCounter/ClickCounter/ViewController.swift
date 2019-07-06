//
//  ViewController.swift
//  ClickCounter
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

//class ViewController: UIViewController {
//
//    var counter = 0
//    var label : UILabel!
//    var toggleBackgroundColor = false
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let label = UILabel()
//        label.frame = CGRect(x: 150, y: 150, width: 50, height: 50)
//        label.text = "0"
//        view.addSubview(label)
//        self.label = label
//
//        let buttonIncrease = UIButton()
//        buttonIncrease.frame = CGRect(x: 250, y: 150, width: 100, height: 50 )
//        //button.setBackgroundImage("click", for: .normal)
//        buttonIncrease.setTitleColor(UIColor.blue, for: .normal)
//        buttonIncrease.setTitle("Increase", for: .normal)
//        view.addSubview(buttonIncrease)
//
//        buttonIncrease.addTarget(self, action: #selector(ViewController.incrementCount), for: UIControlEvents.touchUpInside)
//
//        let buttonDecrease = UIButton()
//        buttonDecrease.frame = CGRect(x: 250, y: 250, width: 100, height: 50 )
//        //button.setBackgroundImage("click", for: .normal)
//        buttonDecrease.setTitleColor(UIColor.blue, for: .normal)
//        buttonDecrease.setTitle("Decrease", for: .normal)
//        view.addSubview(buttonDecrease)
//
//        buttonDecrease.addTarget(self, action: #selector(ViewController.decreaseCount), for: UIControlEvents.touchUpInside)
//
//        let buttonToggleBackground = UIButton()
//        buttonToggleBackground.frame = CGRect(x: 150, y: 350, width: 150, height: 50 )
//        //button.setBackgroundImage("click", for: .normal)
//        buttonToggleBackground.setTitleColor(UIColor.blue, for: .normal)
//        buttonToggleBackground.setTitle("Change BG", for: .normal)
//        view.addSubview(buttonToggleBackground)
//
//        // call函数，当接收到事件的时候执行
//        buttonToggleBackground.addTarget(self, action: #selector(ViewController.toggleBackground), for: UIControlEvents.touchUpInside)
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    @objc func incrementCount(){
//        self.counter += 1
//        self.label.text = "\(self.counter)"
//    }
//
//    @objc func decreaseCount(){
//        self.counter -= 1
//        self.label.text = "\(self.counter)"
//    }
//
//    @objc func toggleBackground(){
//        self.view.backgroundColor = self.toggleBackgroundColor ? UIColor.black: UIColor.white
//        self.toggleBackgroundColor = !self.toggleBackgroundColor
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}


class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!{
        didSet{
            label.text = "0"
        }
    }
    var counter = 0
    @IBAction func increase(_ sender: UIButton) {
        counter += 1
        label.text = "\(self.counter)"
    }
    @IBAction func decrease(_ sender: Any) {
        counter -= 1
        label.text = "\(self.counter)"
    }
    
}

