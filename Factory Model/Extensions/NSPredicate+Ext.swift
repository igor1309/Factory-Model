//
//  NSPredicate+Ext.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import Foundation

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
