//
//  B2CBaseViewController.swift
//  B2CFramework
//
//  Created by Raj Kadam on 17/05/22.
//

import UIKit

class B2CBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func hideNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
