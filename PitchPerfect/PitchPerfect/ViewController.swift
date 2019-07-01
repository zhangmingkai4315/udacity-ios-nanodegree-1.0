//
//  ViewController.swift
//  PitchPerfect
//
//  Created by mingkai on 2019/7/1.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var recodingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordAudio(_ sender: UIButton) {
        print("start recoding the audio")
        recodingLabel.text = "recoding..."
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
    }
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBAction func stopRecording(_ sender: UIButton) {
        recodingLabel.text = "tap to recoding"
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }
    
}

