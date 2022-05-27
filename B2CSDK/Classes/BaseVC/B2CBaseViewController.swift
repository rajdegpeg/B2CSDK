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

    deinit {
        removeObserver()
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Alert view
     func showAlertView(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".lowercased(), style: .default, handler: nil)
            alert.addAction(okAction)
        
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Share Popup
    func showSharePopoup(shareObject: [Any]) {
        
        let activityVC = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        
        
        self.present(activityVC, animated: true, completion: nil)
    }

}
