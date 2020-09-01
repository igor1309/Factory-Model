//
//  DataPoint.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import Foundation

struct DataPoint: Identifiable {
    var id = UUID()
    var title: String
    var value: Double
}

struct DataPointWithShare: Identifiable {
    var id = UUID()
    var title: String
    var value: Double
    var percentage: Double
}
