//
//  TableView.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cellClass: String, bundle: Bundle?) {
        register(UINib.init(nibName: cellClass, bundle: bundle), forCellReuseIdentifier: cellClass)
    }
}
