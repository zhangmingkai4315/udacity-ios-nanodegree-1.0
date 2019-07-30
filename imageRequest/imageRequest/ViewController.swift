//
//  ViewController.swift
//  imageRequest
//
//  Created by mingkai on 2019/7/14.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var displayImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL(string: "https://ichef.bbci.co.uk/news/660/cpsprodpb/13A26/production/_106022408_avnegers976.jpg")!
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if error == nil {
                let downloadImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.displayImage.image = downloadImage
                }
            }
        }
        task.resume()
    }
}

