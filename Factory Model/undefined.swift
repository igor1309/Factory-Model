//
//  undefined.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.08.2020.
//

import Foundation

func undefined<T>(_ message: String) -> T {
    fatalError(message)
}

