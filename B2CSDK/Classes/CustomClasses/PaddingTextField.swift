//
//  PaddingTextField.swift
//  B2CSDK
//
//  Created by Raj Kadam on 17/05/22.
//

import Foundation
import UIKit

class TextFieldWithPadding: UITextField {
    
     let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);

       override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
}
