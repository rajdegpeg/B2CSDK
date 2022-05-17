//
//  RKBasePageControlDelegate.swift
//  Degpeg
//
//  Created by Raj Kadam on 26/04/22.
//

import Foundation

public protocol RKBasePageControlDelegate: AnyObject {
    func didTouch(pager: RKBasePageControl, index: Int)
}
