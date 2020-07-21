//
//  Packaging.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Packaging {
    var code: String {
        get { code_ ?? "Unknown"}
        set { code_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown" }
        set { note_ = newValue }
    }
    var type: String {
        get { type_ ?? "Unknown" }
        set { type_ = newValue }
    }
}
