//
//  ViewController.swift
//  ColorMaker
//
//  Created by mingkai on 2019/7/6.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeColor(_ sender: UISwitch) {
        let r: CGFloat = redSwitch.isOn ? 1 : 0
        let b: CGFloat = blueSwitch.isOn ? 1 : 0
        let g: CGFloat = greenSwitch.isOn ? 1 : 0
        
        colorView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 0.8)
    }
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var blueSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    
    @IBOutlet weak var redProgress: UISlider!
    @IBOutlet weak var greenProgress: UISlider!
    @IBOutlet weak var blueProgress: UISlider!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let r: CGFloat = CGFloat(redProgress.value)
        let b: CGFloat = CGFloat(greenProgress.value)
        let g: CGFloat = CGFloat(blueProgress.value)
        colorView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 0.8)
    }
}

