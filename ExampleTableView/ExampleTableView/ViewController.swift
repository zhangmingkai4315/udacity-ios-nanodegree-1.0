//
//  ViewController.swift
//  ExampleTableView
//
//  Created by mingkai on 2019/7/7.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "CityCell")!
        cell.textLabel?.text = modalData[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var modalData = [
        "Beijing",
        "Shanghai",
        "Guangzhou",
        "Shenzhen"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 必须同时设置delegate和dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

