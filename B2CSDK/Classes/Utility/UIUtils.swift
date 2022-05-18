//
//  UIUtils.swift
//  B2CSDK
//
//  Created by Raj Kadam on 18/05/22.
//

import Foundation
import MBProgressHUD

class UIUtils {
    
    static var view: UIView?
    //MARK:- Show & Hide HUD
    static func showHUD(view: UIView?, message: String = "Loading...") {
        if let view = view {
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = message
            self.view = view
        }
    }
    
    static func hideHUD(view: UIView? = nil) {
        if let view = view {
            MBProgressHUD.hide(for: view, animated: true)
        } else if let previousView = self.view {
            MBProgressHUD.hide(for: previousView, animated: true)
        }
    }
    
}
