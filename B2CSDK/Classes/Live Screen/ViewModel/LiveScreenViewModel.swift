//
//  LiveScreenViewModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 19/05/22.
//

import Foundation
import UIKit
// MARK: Signup
protocol LiveScreenViewControllerProtocol: AnyObject {
    var viewModel: LiveScreenViewModelProtocol? { get set }
    var currentView: UIView? {get set}
    func updateUserData(user: UserDetails)

    func showError(errorString: String)
    
}

protocol LiveScreenViewModelProtocol: AnyObject {
    var viewController: LiveScreenViewControllerProtocol? { get set }
    func getUserData(for providerId: String)
}



final class LiveScreenViewModel: LiveScreenViewModelProtocol {
    var viewController: LiveScreenViewControllerProtocol?
    
    func getUserData(for providerId: String) {
        if NetworkManager.isConnectedToInternet {
            var filter = UserFilter.init()
            let param = filter.createUserFilter(id: providerId)
            
            UIUtils.showHUD(view: viewController?.currentView)
            LiveScreenService().getUserDetails(param: param) { [weak self] user, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let user = user, user.count > 0 {
                    print("User", user[0].email)
                    print("User", user[0])
                    self.viewController?.updateUserData(user: user[0])
                } else {
                    //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: error?.message ?? "Something went wrong")
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }

    }
    
    
}
