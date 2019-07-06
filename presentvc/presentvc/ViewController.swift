//
//  ViewController.swift
//  presentvc
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

    @IBAction func showImagePicker(_ sender: Any) {
        let imvc = UIImagePickerController()
        present(imvc, animated: true, completion: nil)
    }
    
    @IBAction func showActivity(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func showAlert(_ sender: UIButton) {
        let controller = UIAlertController(title: "AlertMe", message: "this is a test alert", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default){ action in
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func randomDiceValue() -> String{
        let random = 1 + arc4random() % 6
        return "\(random)"
    }
    @IBAction func openDiceModal(_ sender: UIButton) {
        performSegue(withIdentifier: "show-dice", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show-dice"{
            if let vc = segue.destination as? DiceViewController{
                vc.value1 = randomDiceValue()
                vc.value2 = randomDiceValue()
            }
        }
    }
    
}

