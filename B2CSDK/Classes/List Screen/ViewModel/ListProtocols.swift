//
//  ListProtocols.swift
//  B2CSDK
//
//  Created by Raj Kadam on 18/05/22.
//

import Foundation
import UIKit
// MARK: Signup
protocol ListViewControllerProtocol: AnyObject {
    var viewModel: ListViewModelProtocol? { get set }
    var currentView: UIView? {get set}
    func updateSectionData(dataArray: [ListSectionData])

    func showError(errorString: String)
    
}

protocol ListViewModelProtocol: AnyObject {
    var viewController: ListViewControllerProtocol? { get set }
    func getContentPublishers(for publisherId: String, showSpinnerFlag: Bool)
    func fetchAllCategories()
}
