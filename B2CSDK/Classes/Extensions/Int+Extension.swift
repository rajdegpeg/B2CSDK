//
//  Int+Extension.swift
//  B2CSDK
//
//  Created by Raj Kadam on 23/05/22.
//

import Foundation

extension Int {
    func formatUsingAbbrevation () -> String {
        let abbrevations = "KMBTPE"
        return abbrevations.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
        } ?? String(self)
    }
}
