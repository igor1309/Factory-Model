//
//  DataPoint.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import Foundation

struct DataPoint: Identifiable {
    let id = UUID()
    var title: String
    var value: Double
}

struct DataPointWithShare: Identifiable {
    let id = UUID()
    var title: String
    var value: String
    var percentage: String
}

struct DataBlock {
    var icon: String
    var title: String
    var value: String
    var data: [DataPointWithShare]
}
