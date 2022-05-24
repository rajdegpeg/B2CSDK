//
//  ViewController.swift
//  B2CSDK
//
//  Created by Raj Kadam on 05/17/2022.
//  Copyright (c) 2022 Raj Kadam. All rights reserved.
//

import UIKit
import B2CSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getFrameworkRootVc() {

        let manager = DegpegManager.init(key: "1234", userId: "6278c4556cb38a7a9c10df6e", userName: "Raj Kadam", influencerID: "6278c4546cb38a7a9c10df6d")
        if let vc = manager.getRootViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}

